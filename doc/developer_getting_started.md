## Developer Getting Started

### Prerequisites

Make sure you have the following installed:

- Git
- Ruby (see `.ruby-version` for the required version)
- Bundler
- SQLite

### Setup

Clone the repository:

```bash
git clone https://github.com/dpi-tta/learn.git
cd learn
```

Install dependencies:

```bash
bundle install
```

Set up the database:

```bash
bin/rails db:prepare
```

Start the application:

```bash
bin/rails server
```

Then open `http://localhost:3000` in your browser.

### Import Lessons

To populate the application with lessons from the `dpi-tta-lessons` GitHub organization, run:

```bash
ruby script/import_lessons_from_github.rb
```

### Run Tests

```bash
bin/rails test
```

### Making Changes

Before starting work:

1. Create or assign yourself an issue.
2. Create a branch using the format:

   ```text
   <issue-number>-<your-initials>-<description>
   ```

   For example:

   ```text
   42-ih-add-search
   ```

3. Make and test your changes.
4. Open a pull request and tag a teammate for review.

For more information, see the documentation in the `doc/` directory.
