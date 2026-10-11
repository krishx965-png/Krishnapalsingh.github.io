# Bal Sabha & LSE Monitoring System

A portfolio case study by Krishnapal Singh Chauhan, covering Hindi form design, conditional questions, school lookup and response validation.

## Deliverables

- Spot Check: 46 questionnaire items.
- Cross-check: 24 questionnaire items.
- Two operational XLSForms prepared separately with 40 eligible schools, selected from the supplied master using Bal Sabha or LSE++ eligibility.
- Interactive website demonstration with three fictitious schools, visible-answer checks and JSON export.

## Form design

A valid nine-digit village code opens the questionnaire and fills school, district, administrative block, EG block, cluster, panchayat and DISE details. Invalid codes keep the questionnaire closed. Activity type and yes/no answers control follow-up sections. Checks cover non-negative counts, allowed session numbers, exclusive “none” selections and dependent question ranges.

The cross-check kit follow-up follows the original Hindi “if yes” wording where the source validation annotation contradicted it. A duplicated source question number was assigned a unique field identifier.

## Public demonstration

Open index.html through the portfolio website and choose either form. Click a demo code, answer questions, change branches, check visible answers and download a JSON response. Hidden answers are excluded from export. No response is uploaded or persisted by this demo. Enter sample responses only.

The operational school master and real XLSForms are not included in this public repository. Public school codes 900000001–900000003 and school names are fictitious.

## Validation and status

Operational lookup expressions were checked offline for all 40 eligible school records, along with key branches. The public rule engine is checked against the questionnaire expressions and representative yes/no paths. Browser and device compatibility still require field testing.

Native KoboToolbox import, deployment and KoboCollect testing remain pending. This website is a portfolio demonstration, not a deployed collection service. No field outcomes or response totals are claimed.

## Files

- index.html and demo.css: responsive interface.
- data.json: public questionnaire specification and synthetic master.
- logic.js: condition and validation expression interpreter.
- demo.js: visibility, lookup, local validation and export.
