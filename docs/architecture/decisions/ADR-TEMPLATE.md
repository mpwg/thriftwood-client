# MADR Template

This project uses [MADR (Markdown Any Decision Records)](https://adr.github.io/madr/) version 4.0.0.

## Filename Convention

`NNNN-short-title-with-dashes.md`

Where NNNN is a sequential number (e.g., 0006, 0007, etc.)

## Official MADR 4.0.0 Template

```markdown
---
# These are optional metadata elements. Feel free to remove any of them.
status: "{proposed | rejected | accepted | deprecated | … | superseded by ADR-0123}"
date: { YYYY-MM-DD when the decision was last updated }
decision-makers: { list everyone involved in the decision }
consulted:
  {
    list everyone whose opinions are sought (typically subject-matter experts); and with whom there is a two-way communication,
  }
informed:
  {
    list everyone who is kept up-to-date on progress; and with whom there is a one-way communication,
  }
---

# {short title, representative of solved problem and found solution}

## Context and Problem Statement

{Describe the context and problem statement, e.g., in free form using two to three sentences or in the form of an illustrative story. You may want to articulate the problem in form of a question and add links to collaboration boards or issue management systems.}

## Decision Drivers

- {decision driver 1, e.g., a force, facing concern, …}
- {decision driver 2, e.g., a force, facing concern, …}
- … <!-- numbers of drivers can vary -->

## Considered Options

- {title of option 1}
- {title of option 2}
- {title of option 3}
- … <!-- numbers of options can vary -->

## Decision Outcome

Chosen option: "{title of option 1}", because {justification. e.g., only option, which meets k.o. criterion decision driver | which resolves force {force} | … | comes out best (see below)}.

### Consequences

- Good, because {positive consequence, e.g., improvement of one or more desired qualities, …}
- Bad, because {negative consequence, e.g., compromising one or more desired qualities, …}
- … <!-- numbers of consequences can vary -->

<!-- This is an optional element. Feel free to remove. -->

### Confirmation

{Describe how the implementation of/compliance with the ADR can/will be confirmed. Are the design that was decided for and its implementation in line with the decision made? E.g., a design/code review or a test with a library such as ArchUnit can help validate this. Note that although we classify this element as optional, it is included in many ADRs.}

## Pros and Cons of the Options

### {title of option 1}

<!-- This is an optional element. Feel free to remove. -->

{example | description | pointer to more information | …}

- Good, because {argument a}
- Good, because {argument b}
<!-- use "neutral" if the given argument weights neither for good nor bad -->
- Neutral, because {argument c}
- Bad, because {argument d}
- … <!-- numbers of pros and cons can vary -->

### {title of other option}

{example | description | pointer to more information | …}

- Good, because {argument a}
- Good, because {argument b}
- Neutral, because {argument c}
- Bad, because {argument d}
- …

<!-- This is an optional element. Feel free to remove. -->

## More Information

{You might want to provide additional evidence/confidence for the decision outcome here and/or document the team agreement on the decision and/or define when/how this decision should be realized and if/when it should be re-visited. Links to other decisions and resources might appear here as well.}
```

## Thriftwood-Specific Guidelines

1. **Keep it concise**: ADRs should be readable in 5-10 minutes
2. **Focus on "why"**: Explain the rationale, not just the decision
3. **Include context**: Future readers need to understand the constraints
4. **Document alternatives**: Show you considered multiple options
5. **Be honest**: List the bad consequences too
6. **Link to code**: Reference implementation examples where helpful (Swift code blocks)
7. **Cross-reference**: Link related ADRs and migration milestones
8. **Use metadata**: Fill in status, date, and decision-makers in YAML frontmatter

## When to Create an ADR

Create an ADR when making decisions about:

- **Architecture patterns**: MVVM-C, coordinators, service layers
- **Technology choices**: Frameworks, libraries, package dependencies
- **Data flow**: State management, persistence strategies
- **API design**: Service protocols, networking approaches
- **Testing strategies**: Mocking patterns, test organization
- **Security**: Authentication, credential storage
- **Performance**: Caching strategies, optimization techniques

## ADR Lifecycle (Status Values)

- **proposed**: Draft ADR for discussion
- **accepted**: Decision made and documented
- **deprecated**: No longer recommended but not yet superseded
- **superseded by ADR-NNNN**: Replaced by a newer ADR (reference the new ADR)
- **rejected**: Considered but not chosen

## Storage Location

Store ADRs in: `/docs/architecture/decisions/`

Update the README.md in that directory to list all ADRs with their status.

## References

- [MADR Homepage](https://adr.github.io/madr/)
- [MADR 4.0.0 Template](https://github.com/adr/madr/blob/4.0.0/template/adr-template.md)
