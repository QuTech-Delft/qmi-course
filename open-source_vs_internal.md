---
title: "Open-source vs internal code"
output: html_document
teaching: 10
exercises: 0
---

::: questions
-   What is the difference between different QMI codebases?
-   How is the development done for QMI software?
-   Can I make requests and|or contribute?
:::

::: objectives
-   Know what is the difference between the open-source and internal QMI
-   Know how to make requests and how to contribute to the development
:::

## QMI open-source vs internal code

QMI has its main development as an open-source software (OSS). But it has also a close-source version (CSS) for development mainly due to licensing reasons as QMI uses also some manufacturer software and libraries. Also for some projects it might be preferable to keep certain aspects out of plain sight during their course. The software can be found in
-	OSS: https://github.com/QuTech-Delft/QMI (public)
-	CSS: https://gitlab.tudelft.nl/qmi/qmi (private, you need to be invited to access)
repositories.

## Code base and development

By browsing the repositories from the links above (if you have access for both), you can get familiar with the code base of both projects. You will see things on the site like “Issues” or “Pull requests” (Github) | “Merge requests” (Gitlab) and “Issue Board” (Gitlab) among others. The development is done normally by tackling the “Issues”. We can call them as “Issue tickets” or just “tickets” as well.
 
![Figure 2: An issue list in Github.](figures/Github_issue_list.png)

The use of such issue list is that we want to have more traceable and logical system for the development. If a developer or user notices a bug or another issue with the code, or would like to have new features or functionalities, it is best to describe it (as well as possible) in an issue ticket, instead of immediately starting to bash through some changes in the code and try to push that through in the code base. In any case where there is more than one person involved in the code base (and usually even for the lone wolf developer) this is a good idea to prevent too eager contributors messing up the code.

### Creating a new issue ticket

To avoid the “writer’s block” when creating a new ticket, templates are available for different ticket types. The templates have a structure ready and a description what should be written in different parts of the ticket. The templates do not need to be written 100% full if some parts are not applicable, though. Use your judgement also. In general applies: The more detailed request with clear description of the desired outcome, perhaps even with a little bit of (meta)code, the easier the ticket is to evaluate and execute, and eventual pull|merge request reviewed. 
Another common pitfall to avoid is to make too large tickets. If the new feature request starts to get really complex, perhaps it is better to think how it can be split into two or more smaller tickets, with clear reachable goals for each ticket, which together then fulfill the request. This might also be done during the evaluation of the issue, see below the description of ticket progress in QMI.

### Tracking issue progress on a board
A ticket progress can be followed on a issue board. A board consists of at least “new” or “open” column and “done” or “closed” columns. In between there can be several other columns to keep track of the ticket progress, like “refinement”, “in progress”, “for review” and others. Below is an example of QMI OSS (private) issue development board. 
 
![Figure 3: QMI issue development board.](figures/Github_devboard.png)

The general progress order is from left to right, where first new issues are made in the first column. If the ticket is written clear and concise enough, it can be moved to be evaluated by the team in “To poker” column.  Here, the ticket is “pokered” to have an effort score and can then be then moved to “Backlog” column to wait someone to start working on the issue. Or directly to “In progress” if the issue is going to be worked on straight away. In the code base a new branch is opened (usually from main branch for the repository) to work on the ticket. When the ticket is ready, a pull|merge request is made for the request and the ticket is moved into the “In review” column. Another developer must review the ticket and accept it before the new code in the new branch can be merged. After the code is merged back to its origin, the issue can be moved into the “Pending release” column. When ‘enough’ (term is relative here) issues are in this column, a new release of the code can be made and finally the ticket is moved into “Done”.

We can also move tickets back to left, e.g. if the issue description is not proper for “pokering”, we can send it back to “New issues” to indicate better description is needed. Sometimes, the issue is so large that tackling it in one ticket becomes way too cumbersome. Then splitting it into several smaller new issues is necessary. Quite often also tickets  “In review” do not get accepted with extra work needed on the ticket, often the ticket being moved back to “In progress”. 

A specialty if the board in Figure 3 is the “Epics” column. This column has issue tickets that are actually descriptions of a large feature request or larger changes in the code base. The Epic ticket describes what is the total goal and how to reach it taking smaller steps, i.o.w. by executing several smaller issue tickets. The aforementioned splitting of a large ticket during evaluation could also result into creation of such Epic issue so that the overall progress, which could span even over multiple releases, can be tracked better.

Now you will be showcased how to make a ticket on a board and how to select a template for it.

## Contributing

The users can also pick up their own tickets and develop code in their own branches, and offer them for merging, too! Such contributions are more than welcome as there’s not too many dedicated SW engineers for development. For QMI, we do aim to keep a certain coding style and have some quality requirements for any contribution. QMI coding standard is explained [here](https://qmi.readthedocs.io/en/latest/coding_standard.html) and a simple guide on how to proceed is [here](https://github.com/QuTech-Delft/QMI/blob/main/CONTRIBUTING.md#development). Note that just delivering code for the bug fix or requested feature is not enough: the code must include also unit-tests and pass the CI-pipelines, fulfilling our [acceptance criteria](https://github.com/QuTech-Delft/QMI/blob/main/TESTING.md%23acceptance-criteria). Only then the pull|merge request can be approved and merged. Other valuable points for [good coding practices](https://qutech-delft.github.io/imsep/clean-code.html) were mentioned in the IMSEP course.


::: keypoints
-   In Github we have open-source QMI and in Gitlab the internal closed-source QMI
-   Users can make requests via opening new issues a.k.a. tickets in the repository
-   You can and are welcome to contribute too! Just follow the guidelines
:::
