# Docbert

Docbert is a living documentation tool that makes use of cucumber to execute its
specifications. You could call it "literate cucumber."

## Why docbert?

Cucumber places the emphasis on the executable part of a specification. Docbert
places the emphasis on the specification itself, and uses cucumber
scenarios as **examples**--a way to enrich the specification--as well as
tests. This allows you to write specifications using a much richer vocabulary,
including finer-grained structure, images and linking, and makes it easy to
connect related ideas that live in different feature files.

## Writing

To write docbert documents, simply write markdown--more specifically, the
[kramdown variant](http://kramdown.rubyforge.org/syntax.html)--and enclose
cucumber scenarios (renamed to examples) in an example block.

Note the following:

  * Don't use the `Feature:` declaration. The feature name will be automatically
    extracted from the file's `h1` header.

  * Don't use `Background` blocks. Use [Definitions](#definitions) instead.

Docbert examples begin with an example declaration, which also contains the
example title. Its format is as follows:

    Example: writing a feature, docbert-style

      Given I am a business analyst
      When I write a feature, docbert-style
      Then my feature writing skill level automatically surpasses 9000

The example title should be placed on a line by itself. It will be turned into
the cucumber scenario title. If you indent it with 4 spaces relative to the
previous indentation, it will be considered a code block and will still render
nicely on markdown renderers that don't understand the docbert extensions. If
you don't indent the example block, then everything up to the end of the file will be
considered part of the cucumber scenario, unless you use a kramdown end-of-block
marker.

Next follows the example body, which consists of cucumber steps. The example
body should have at least the same indentation as the example declaration (but I
like it better with an extra 2-space indentation).

### Example Outlines

Example outlines are the equivalent of cucumber's scenario outlines, and they
work in the same manner. The only difference is that you declare them using
`Example Outline` instead of `Scenario Outline`:

    Example Outline: everyone writes a feature, docbert-style

      Given I am a <role>
      When I write a feature, docbert-style
      Then my feature writing skill level automatically surpasses 9000

      Examples:
        | role               |
        | business analyst   |
        | software developer |
        | tester             |

### Definitions

A definition is a reusable group of steps that behaves as a single step when
used. Definitions allow you to encapsulate common behavior while keeping it
transparent to feature readers. Its format is like that of an example, but you
start the block with `Definition:` instead.

    Definition: I submit the signup form with valid data

      When I fill in the signup form with the following values:
        | field 1 | value 1 |
        | field 2 | value 2 |
      And I submit the signup form

Once defined, a definition can be used as any other step:

    Example: using a definition

      Given I am on the signup page
      When I submit the signup form with valid data
      Then I should be signed up

## Executing

There is no way to execute a docbert feature, because a docbert feature isn't
executable. Instead you use `doc2cuke` to convert the docbert feature to a
cucumber feature. Docbert will simply pick all example blocks, turn them into
scenarios and dump them into a cucumber feature file. Non executable
documentation won't be copied to the cucumber feature file.

    Example: converting a docbert-style feature to a cucumber feature

      When I run "doc2cuke features/docbert.feature.md"
      Then it should generate the feature "features/docbert.feature"
      And "features/docbert.feature" should contain the following scenarios:
        | writing a feature, docbert-style                         |
        | using a definition                                       |
        | converting a docbert-style feature to a cucumber feature |
      And "features/docbert.feature" should contain the following scenario outlines:
        | everyone writes a feature, docbert-style |

## TODO

  * Tag support
  * Definition placeholders
  * Pending examples
