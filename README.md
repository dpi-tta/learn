# Learn

This application is used to share lessons written in the <https://github.com/orgs/dpi-tta-lessons> organization and make them easily accessible.

## Contributing

- Please create (or assign yourself) an issue.
- Please make a branch following format `<issue-number>-<your-initials>-<description>` (eg `1-ih-add-quiz`).

## Importing Lessons

Run the script `ruby script/import_lessons_from_github.rb` to import all lessons from <https://github.com/orgs/dpi-tta-lessons>.

## Writing Lessons

### Code Snippets

You can write standard Markdown code snippets and get syntax highlighting (powered by Prism).

```html
<h1>Hello, world!</h1>
```

### Code Snippet REPLs (Read, Evaluate, Print, Loop)

Use [Kramdown](https://kramdown.gettalong.org/syntax.html#inline-attribute-lists) inline attribute `.repl` class to generate an inline code editor.

```html
<h1>Hello, world!</h1>
```
{: .repl }
