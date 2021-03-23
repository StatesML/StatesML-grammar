# StatesML-grammar

An Antlr4 grammar for the States Modeling Language (StatesML).

Documents one approach to lexing and parsing StatesML into an intermediate representation suitable for producing the StatesML state graph.

**NOTE:** This is a work in progress.

## StatesML

The States Modeling Language is a domain specific language (DSL) for declaratively defining [finite state machines](https://en.wikipedia.org/wiki/Finite-state_machine) and [statecharts](https://www.sciencedirect.com/science/article/pii/0167642387900359/pdf). 

StatesML produces a JSON-serializable graph of state, transition and action nodes that can be imported directly or easily transformed into input formats expected by FSM and Statechart engines, visualizers and code generators.

It is intended to define a shared syntax and interchange representation in order to promote the development of a constellation of compatible FSM and statechart tools, engines and code generators across myriad languages and platforms.

## Design Goals

**Do less in order to do more**

* Favor simplicity - prefer a smaller, fixed set of well-considered features in order to:
  * lighten the compatibility burden for creating new tools,
  * reduce the learning curve for using those tools,
  * maximize the common surface area that can be shared across related tools,
  * and still allow room for implementors to innovate at the edges.
* Strictly constrain features to those necessary to declaratively describe the shape of the state graph.
* Leave condition/service/assignment/action/result procedural logic as external references delegated to the host engine or language.
* Eliminate as much syntax noise as possible to hew as closely as code can to the visual programming nature of statecharts.
* Explore the question: "what would it look like if statecharts were a first class language feature as common as `enum` or `switch` statements?"
* Align around a core simplified subset of a recent consensus for statechart semantics, the [W3C SCXML specification](https://www.w3.org/TR/scxml/).

## Example

```statesml
machine CatAPI {
  state idle {
    on FETCH -> loading
  }
  state loading {
    invoke fetchCat() {
      onDone -> resolved {
        setCatPicture()
      }
      onError -> rejected
    }
    on PROGRESS {
      updateProgress()
    }
    on CANCEL -> idle
    on FETCH re-enter loading
  }
  final resolved
  state rejected {
    on FETCH -> loading
  }
}
```

## Related Projects (currently in development)

* `StatesML-cli` - a command-line tool to parse, format, convert between `.statesml` and `.statesml.json` files, and more
* `StatesML-parser` - a hand-written reference lexer and parser for StatesML written in TypeScript
* `StatesML-validator` - a TypeScript library that validates a StatesML graph and produces diagnostics
* `StatesML-language` - a VSCode extension and an [LSP](https://microsoft.github.io/language-server-protocol/) language server, featuring:
  * syntax highlighting 
  * diagnostics to surface suggestions, warnings and errors
  * hover detail with types, description and documentation
  * autocomplete
  * visualization and step simulation
* `xstate-StatesML` - a TypeScript library to generate [XState](https://xstate.js.org) compatible machine definitions from `.statesml` and `.statesml.json` files.
* `babel-plugin-statesml-tag` - a Babel plugin to compile StatesML tagged literals into their graph representation.
