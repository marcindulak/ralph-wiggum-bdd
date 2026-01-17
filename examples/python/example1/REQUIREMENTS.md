# Temperature Conversion Tool Requirements

We need a command-line utility for converting temperatures between Celsius and Fahrenheit scales.
The tool should be easy to use for quick conversions without requiring a calculator or online converter.

Functional Requirements

| Feature (FR) | Designer's Note |
|---|---|
| Tool converts temperature from Celsius to Fahrenheit | Standard conversion formula |
| Tool converts temperature from Fahrenheit to Celsius | Standard conversion formula |
| Tool rejects temperatures below absolute zero | -273.15°C or -459.67°F |
| Tool accepts temperature value and unit as command-line arguments | CLI interface |
| Tool displays converted value with units | Output format |
| Tool displays allowed unit values when invalid unit is provided | Error message |

Non-Functional Requirements

| Feature (NFR) | Quality Attribute | Designer's Note |
|---|---|---|
| Tool is implemented in Python | Portability | Python |
| Tool is testable with Behave | Testability | Gherkin-based BDD testing |
| Tool provides error messages for invalid input | Usability | Handle user errors |
| Conversions complete instantaneously | Performance | Mathematical operations |

The first decision is what programming language to use.
We chose Python as specified in the non-functional requirements.

For testing, we chose Behave as the BDD framework.
Behave allows writing executable specifications in Gherkin format, making requirements directly testable.

Tests must be executed using the `behave` command directly (not `python -m behave`).
Example: `behave features/001.feature` or `behave features/`.
