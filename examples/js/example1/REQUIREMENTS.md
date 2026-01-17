# Counter Application Requirements

We need a web application that displays and manages a numeric counter.
The counter should allow users to increment and decrement the value.

Functional Requirements

| Feature (FR) | Designer's Note |
|---|---|
| Application displays a counter with initial value of zero | Initial state |
| Clicking the increment button increases the counter by one | User interaction |
| Clicking the decrement button decreases the counter by one | User interaction |
| Counter value updates on the display | Visual feedback |

Non-Functional Requirements

| Feature (NFR) | Quality Attribute | Designer's Note |
|---|---|---|
| Application is implemented in vanilla JavaScript | Technology choice | HTML/CSS/JS |
| Application interface runs in a web browser | Interface | Static files served locally |
| Application is testable with Playwright BDD | Testability | Gherkin-based BDD testing framework |
| Tests execute within a Docker container | Environment | Node.js LTS container |

The first decision is the technology stack for the web application.
We chose vanilla JavaScript with HTML and CSS.

For testing, we chose Playwright BDD as the testing framework.
Playwright BDD allows writing executable specifications in Gherkin format using Playwright for headless browser automation.

Docker workflow for testing:
1. Start a detached container: `docker run -d -v $(pwd):/workspace --name playwright-counter mcr.microsoft.com/playwright:latest sleep infinity`
2. Install dependencies once: `docker exec playwright-counter bash -c "cd /workspace && npm install"`
3. Run tests: `docker exec playwright-counter npm test`
4. Clean up: `docker stop playwright-counter && docker rm playwright-counter`

Note: The official Playwright container image includes all browser binaries and system dependencies pre-installed.
