#!/usr/bin/env python3
# coding: utf-8
"""Parse Priestley's Biographic Descriptions

This script parses text files with the biographic descriptions from
Priestley's "A Chart of History".
"""
import argparse
import json
import re

import yaml
from arpeggio import RegExMatch as _
from arpeggio import (EOF, NoMatch, Not, OneOrMore, Optional, ParserPython,
                      PTNodeVisitor, visit_parse_tree)


DOTS_YEARS = 10
"""Number of years associated with a 'dot' in Priestley's Chart."""


def load_categories(filename):
    """Read Priestley's categories from YAML file."""
    with open(filename, "r") as f:
        data = yaml.load(f)
    categories = {}
    for d in data['divisions']:
        for cat, v in d['occupations'].items():
            categories[cat] = d['name']
    return categories


class Visitor(PTNodeVisitor):
    """Visitor Class for Parsed Biographies"""

    def __init__(self, occupations, **kwargs):
        self.occupations = occupations
        super().__init__(**kwargs)

    def visit_after(self, node, children):
        return "after"

    def visit_about(self, node, children):
        return "about"

    def visit_integer(self, node, children):
        return int(str(node))

    def visit_century(self, node, children):
        bc = len(children.bc) > 0
        if self.debug:
            print(bc)
        values = children.integer
        if len(values) == 2:
            value = sum([x - 0.5 for x in values]) / len(values) * 100
        elif len(values) == 1:
            value = values[0] * 100 - 50
        if bc:
            value *= -1
        return value

    def visit_year(self, node, children):
        if self.debug:
            print(children)
            print(node)
        value = children[0]
        # if BCE, then need to adjust it so that 1 BCE = 0
        if len(children) > 1:
            value = -value + 1
        return value

    def visit_name(self, node, children):
        return ' '.join(str(x) for x in children)

    def visit_occupation(self, node, children):
        occupation = ' '.join(children)
        return occupation

    def visit_died_prefix(self, node, children):
        out = 'died'
        if len(children):
            out = out + '_' + str(children[0])
        return out

    def visit_died(self, node, children):
        return {children[0]: children[1]}

    def visit_born_prefix(self, node, children):
        if self.debug:
            print(node)
            print(children)
        out = 'born'
        if len(children):
            out = out + '_' + str(children[0])
        return out

    def visit_born(self, node, children):
        if self.debug:
            print(node)
            print(children)
        return {children[0]: children[1]}

    def visit_lived_prefix(self, node, children):
        out = 'lived'
        if len(children):
            out = out + '_' + str(children[1])
        return out

    def visit_lived(self, node, children):
        return {children[0]: children[1]}

    def visit_flourished_prefix(self, node, children):
        out = 'flourished'
        if len(children):
            out = out + '_' + str(children[0])
        return out

    def visit_flourished_century(self, node, children):
        return {'flourished_century': children[1]}

    def visit_flourished_year(self, node, children):
        return {children[0]: children[1]}

    def visit_age(self, node, children):
        if self.debug:
            print(node)
            print(children)
        if len(children) > 1:
            out = {'age_' + children[0]: children[1]}
        else:
            out = {'age': children[0]}
        if self.debug:
            print(out)
        return out

    def visit_period(self, node, children):
        return None

    def visit_born_expr(self, node, children):
        out = children[0]
        if len(children) > 1:
            out.update(children[1])
        return out

    def visit_died_expr(self, node, children):
        if self.debug:
            print(node)
            print(children)
        out = children[0]
        if len(children) > 1:
            out.update(children[1])
        return out

    def visit_flourished_expr(self, node, children):
        if self.debug:
            print(node)
            print(children)
        out = children[0]
        if len(children) > 1:
            out.update(children[1])
        return out

    def visit_bio(self, node, children):
        out = children[1]
        out['name'] = children.name[0]
        if len(children.occupation):
            occupation = children.occupation[0]
            if occupation.startswith('H P.'):
                out['occupation'] = occupation[:3]
                if len(occupation) > 4:
                    out['sect'] = occupation[4:].strip()
            else:
                out['occupation'] = occupation
            out['division'] = self.occupations[out['occupation']]
        else:
            out['division'] = 'Statesmen and Warriors'
        return out


def word():
    return Not(["d.", "fl.", "b."]), _(r"\S+")


def punct():
    return [",", ".", "(", ")"]


def integer():
    return _("[0-9]+")


def name():
    return OneOrMore([word, punct])


def after():
    return "af."


def about():
    return "ab."


def above():
    return "above"


def before():
    return "before"


def bc():
    return "BC"


def period():
    return "."


def year():
    return integer, Optional(bc)


def century():
    return Optional("in"), Optional(about), integer, Optional(
        "or", integer), "Cent.", Optional(bc)


def born_prefix():
    return "b.", Optional(about)


def born():
    return born_prefix, year


def lived_prefix():
    return ["l.", "liv."], Optional(after)


def lived():
    return lived_prefix, year


def died_prefix():
    return "d.", Optional([after, about])


def died():
    return died_prefix, year


def flourished_prefix():
    return "fl.", Optional([after, about, before]),


def flourished_year():
    return flourished_prefix, year


def flourished_century():
    return flourished_prefix, century


def flourished():
    return [flourished_century, flourished_year]


def age():
    return Optional([about, above]), integer


def born_expr():
    return born, Optional(period), Optional([age, lived, died])


def died_expr():
    return died, Optional(period), Optional([age, lived, born])


def flourished_expr():
    return flourished, Optional(period), Optional([age, lived, died])


def occupation():
    return [
        "Engineer", *(f"H P. {k}"
                      for k in [
                          "Ion", "Soc", "Cyr", "Meg", "Eleat", "Ac", "Per",
                          "Sto", "Cyn", "Ital", "Scept", "Ep", "Eleack"
                      ]), "H P.", "Bell", "Trav", "Moh", "Met", "Mor", "Pol",
        "Chy", "Act", "Eng", "Geo", "Ant", "Bel", "Ph", "Po", "Pa", "St", "Mu",
        "Pr", "Ar", "Cr", "Or", "Ch", "P", "H", "L", "J", "F", "D", "M", "R"
    ]


def bio():
    return (name, [died_expr, flourished_expr, born_expr], Optional(period),
            Optional(occupation), Optional(period), EOF)


def format_year(x):
    return str(x) if x > 0 else str(x - 1) + " BCE"


def add_intervals(x):
    """Add start and end years to intervals."""
    life_type = tuple(
        sorted([
            k for k in x
            if re.match("died|born|lived|flourished|age", k)
        ]))
    x['lifetype'] = life_type

    if life_type == ("age", "born"):
        # Exact birth and death dates
        died = x["born"] + x['age']
        # provides exact birth and death dates
        x["born_min"] = x["born_max"] = x["born"]
        x["died_min"] = x["died_max"] = x["died"]
    elif life_type == ("age", "died"):
        # provides exact birth and death dates
        born = x["died"] - x["age"]
        x["born_min"] = x["born_max"] = born
        x["died_max"] = x["died_min"] = x["died"]
    elif life_type == ("age", "died_about"):
        # Ignore uncertainty with "about"
        x['died_min'] = x['died_about'] - 5
        x['died_max'] = x['died_about'] + 5
        x['born_max'] = x['died_max'] - x['age']
        x['born_min'] = x['died_min'] - x['age']
    elif life_type == ("age", "died_after"):
        x['died_min'] = x['died after']
        x['died_max'] = x['died_min'] + 10
        # died after uncertainty perpetuates through age
        x['born_max'] = x['died_max'] - x['age']
        x['born_min'] = x['died_min'] - x['age']
    # elif life_type == ("age", "flourished"):
    #     # use exact values for age and the 2/3 rule for flourished
    #     fl = x['flourished']['value']
    #     age = x['age']
    #     x["died_min"] = fl + (1 / 3) * age
    #     x["died_max"] = x["died_min"]
    #     x["born_max"] = fl - (2 / 3) * age
    #     x["born_min"] = x["born_max"]
    elif life_type == ("age_about", "born"):
        # ignore uncertainty with about
        x['born_min'] = x['born_max'] = x['born']
        x['died_min'] = x['born'] - 5
        x['died_max'] = x['born'] + 5
    elif life_type == ("age_about", "died"):
        # ignore uncertainty with about
        x['died_min'] = x['died_max'] = x['died']
        x['born_max'] = x['died'] - x['age about'] + 5
        x['born_min'] = x['died'] - x['age about'] - 5
    elif life_type == ("age about", "died after"):
        x['died_min'] = x['died_after']
        x['died_max'] = x['died_after'] + 10
        x['born_max'] = x['died_max'] - x['age about'] + 5
        x['born_min'] = x['died_min'] - x['age about'] - 5
    elif life_type == ("age about", "died about"):
        # apply maximum uncertainty
        # treating the intervals as normal it would be 2 * sqrt(2 * 2.5^2) but
        # that is probably not what Priestley did.
        x['died_min'] = x['died about']['value'] - 5
        x['died_max'] = x['died_about']['value'] + 5
        x['born_max'] = x['died_max'] - x['age about'] + 5
        x['born_min'] = x['died_min'] - x['age about'] - 5
    elif life_type == ("age above", "born"):
        x['born_max'] = x['born_min'] = x['born']
        x['died_min'] = x['born'] + x['age above']
        x['died_max'] = x['born'] + x['age above'] + 10
    elif life_type == ("age above", "died"):
        x['died_min'] = x['died_max'] = x['died']
        x['born_max'] = x['died_min'] - x['age above']
        x['born_min'] = x['died_min'] - x['age above'] - 10
    elif life_type == ("age above", "died after"):
        x['died_min'] = x['died_after']
        x['died_max'] = x['died_after'] + 10
        x['born_max'] = x['born_min'] = x['died_max'] - x['age above']
    elif life_type == ("born", ):
        x["born_min"] = x["born"]
        x["died_min"] = x["born"] + 30
        x["died_max"] = x["born"] + 70
    elif life_type == ("born", "died"):
        x["died_min"] = x["died_max"] = x['died']
        x["born_max"] = x["born_max"] = x['born']
    elif life_type == ("born", "died after"):
        x['born_max'] = x['born_min'] = x['born']
        x['died_min'] = x['died after']
        x['died_max'] = x['died_after'] + 10
    elif life_type == ("born", "lived after"):
        x["born_max"] = x["born_min"] = x["born"]
        x["died_min"] = x["lived after"]
        x["died_max"] = x["lived_after"] + 10
    # elif life_type == ("born about", ):
    #     x["born_min"] = x["born about"]["value"] - 5
    #     x["born_max"] = x["born about"]["value"] + 5
    #     x["died_min"] = x["born_max"] + 25
    #     x["died_max"] = x["died_min"] + 35
    elif life_type == ("born about", "died"):
        x['died_min'] = x['died_max'] = x['died']
        x['born_max'] = x['born about'] + 5
        x["born_min"] = x["born about"] - 5
    # elif life_type == ("born before", ):
    #     x["born_max"] = x["born before"]["value"]
    #     x["born_min"] = x["born_max"] - 10
    #     x["died_min"] = x["born_max"] + 30
    #     x["died_max"] = x["died_min"] + 30
    elif life_type == ("died", ):
        x['died_min'] = x['died_max'] = x['died']
        x['born_max'] = x['died'] - 30
        x['born_min'] = x['died'] - 70
    # elif life_type == ("died about", ):
    #     x['died_min'] = x['died about']['value']
    #     x['born_max'] = x['died_min'] - 30
    #     x['born_min'] = x['born_max'] - 40
    # elif life_type == ("died after", ):
    #     x['died_min'] = x['died after']['value']
    #     x['died_max'] = x['died_min'] + 10
    #     x['born_max'] = x['died_min'] - 20
    #     x['born_min'] = x['born_max'] - 40
    # elif life_type == ("flourished", ):
    #     fl = x['flourished']['value']
    #     x["born_max"] = fl - 20
    #     x["born_min"] = x['born_max'] - 30
    #     x["died_min"] = fl + 10
    #     x["died_max"] = x["died_min"] + 20
    # elif life_type == ("flourished after", ):
    #     # treat the same as flourished
    #     fl = x['flourished after']['value']
    #     x["born_max"] = fl - 20
    #     x["born_min"] = x['born_max'] - 30
    #     x["died_min"] = fl + 20
    #     x["died_max"] = x["died_min"] + 20
    # elif life_type == ("flourished before", ):
    #     # treat the same as flourished
    #     fl = x['flourished before']['value']
    #     x["born_max"] = fl - 20
    #     x["born_min"] = x["born_max"] - 30
    #     x["died_min"] = fl + 10
    #     x["died_max"] = x["died_min"] + 20
    # elif life_type == ("flourished about", ):
    #     fl = x["flourished about"]['value']
    #     x["born_min"] = fl - 50
    #     x["died_max"] = fl + 30
    elif life_type == ("age about", "born about"):
        x['born_min'] = x["born_about"] - 5
        x["born_max"] = x["born_about"] + 5
        x["died_min"] = x["born_about"] + x["age_about"] - 10
        x["died_max"] = x["born_about"] + x["age_about"] + 10
    else:
        print("unknown type: ", life_type)
        print(x)

    # if 'born_max' in x and 'born_min' not in x:
    #     x['born_min'] = x['born_max']
    # if 'died_min' in x and 'died_max' not in x:
    #     x['died_max'] = x['died_min']
    #

def parse(filename, outfile, categories_filename):
    parser = ParserPython(bio)
    categories = load_categories(categories_filename)
    visitor = Visitor(categories)
    data = []
    with open(filename, "r") as f:
        for line in f.readlines():
            # remove URLs
            # ignore lines starting with spaces
            if re.match(r"^[ \t]", line) or line == "\n":
                continue
            m_url = re.search("<(.*)>", line)
            if m_url:
                url = m_url.group(1)
                line = re.sub("<.*>", "", line).strip()
            else:
                url = None
            m = re.search(r"(.*)\[(.*)\]\s*$", line)
            if m:
                line = m.group(1).strip()
                editions = set(m.group(2).split(';'))
                in_1764 = '1764' in editions
                in_names_omitted = 'Names Omitted' in editions
                in_1778 = '1778' in editions
            else:
                in_1764 = True
                in_1778 = True
                in_names_omitted = False
            try:
                parse_tree = parser.parse(line.strip())
                try:
                    parsed = visit_parse_tree(parse_tree, visitor)
                except IndexError as exc:
                    raise exc
            except NoMatch as exc:
                print("ERROR:", line)
                parsed = {}
            parsed['text'] = line.strip()
            parsed['in_1778'] = in_1778
            parsed['in_1764'] = in_1764
            parsed['in_names_omitted'] = in_names_omitted
            parsed['url'] = url
            data.append(parsed)
    # add_intervals(data)
    with open(outfile, "w") as f:
        json.dump(data, f, indent=1)


def main():
    parser = argparse.ArgumentParser(
        description=("Parse text files with Priestley bios and output JSON "
                     "file.")
    )
    parser.add_argument('--categories-filename', type=str,
                        help="Path to YAML file with Priestley's categories.",
                        default="Categories.yml")
    parser.add_argument('filename', type=str,
                        help="Path to input text file.")
    parser.add_argument('-o', '--outfile', type=str,
                        help='Path to output JSON file')
    args = parser.parse_args()
    parse(args.filename, args.outfile, args.categories_filename)


if __name__ == '__main__':
    main()
