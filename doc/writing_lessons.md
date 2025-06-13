# Writing Lessons

## Markdown

Lessons should be written in [Markdown](https://www.markdownguide.org/basic-syntax/). Here is a [lesson template](https://github.com/dpi-tta-lessons/lesson-template).

## Praxis Framework

A good praxis for writing practical software lessons for beginners should balance theory, pedagogy, and usability. Here's a recommended approach that integrates Minimalism, Cognitive Load Theory, and Scaffolded Learning.

### 1. Task-First Orientation (Minimalism)

- Start with a goal: Each lesson should help the learner do something real (e.g., "Build a to-do list app," "Write a loop that processes input").
- Cut the fluff: Minimize background theory; teach concepts only as they become immediately useful.

> ✍️ "Today you’ll build a simple weather app. First, we’ll show you how to fetch data from an API."

### 2. Chunking and Progression (Cognitive Load Theory)

- Break lessons into small steps: Don’t present large code blocks or multiple new ideas at once.
- Gradually increase complexity: Scaffold knowledge—introduce one concept per step, building on earlier ones.

> 🧠 Avoid introducing callbacks, promises, and APIs in the same lesson if the learner is new to JavaScript.

### 3. Show, Then Do (Constructivist Learning)

- Show a complete working example: Let learners see what they’ll build.
- Then walk through it line by line: Offer micro-explanations.
- Follow with a hands-on task: Let learners adapt or extend the example.

> 🛠️ "This is a 'for loop'. Try modifying it to count down instead of up."

### 4. Layered Explanation (Progressive Disclosure)

- Start simple: Offer a shallow explanation that’s enough to proceed.
- Offer deeper dives: Use expandable sections, tooltips, or links to explain more as curiosity grows.

> 📘 "Don’t worry about what `map()` does just yet, we’ll break it down below."

### 5. Frequent Feedback

- Check for understanding often: Add mini-quizzes, true/false checks, or error-prediction tasks.
- Use immediate inline feedback: If possible, code runners or REPLs that respond in real time.

> ❓"What will this code output?" with an embedded code sandbox.

### 6. Real-World Relevance

- Tie concepts to real-world use cases: Explain why this matters—what problems it solves.
- Use familiar metaphors: Make abstract ideas concrete (e.g., "a class is like a blueprint").

### 7. Error-Friendly Environment

- Anticipate mistakes: Call out common bugs or misunderstandings.
- Normalize failure: Include examples of code that doesn’t work, then debug it together.

> ⚠️ "Notice the missing semicolon here. This is a common mistake, let’s fix it."

## Structural Template for a Lesson

1. Lesson Title: What they will build/do.
2. Goal Overview: One-sentence summary of what the learner will achieve.
3. Live Preview or Demo (if possible)
4. Step-by-Step Task Instructions:

  - 1–2 lines of instruction
  - Code snippet
  - Output or expected result
  - Optional "Why this works" box

5. Practice Challenge: Change one aspect of the code
6. Wrap-Up: Summary, next steps, links to deeper concepts
7. Quiz or Checkpoint (optional)

## Code Snippets

You can write standard Markdown code snippets and get syntax highlighting (powered by Prism).

```html
<h1>Hello, world!</h1>
```

## Code Snippet REPLs (Read, Evaluate, Print, Loop)

Use [Kramdown](https://kramdown.gettalong.org/syntax.html#inline-attribute-lists) inline attribute `.repl` class to generate an inline code editor.

```html
<h1>Hello, world!</h1>
```
{: .repl }

## `<aside>`

Use `<aside>` elements to include supplementary content—like tips, context, definitions, or even warnings—without interrupting the main narrative.

```html
<!-- You can use .tip, .warning, or .danger -->
<aside class="tip">
  <strong>Tip:</strong> You can use Ctrl + F to search this page quickly.
</aside>
```

## Videos

`<video src="video.mp4" width="480" autoplay loop muted playsinline></video>`

## GIFs

Use the terminal with `ffmpeg` to create GIFs

### 1. Install `ffmpeg` using Homebrew (macOS)

```bash
brew install ffmpeg
```

### 2. Run this command to convert MP4 to GIF

```bash
ffmpeg -i input.mp4 -vf "fps=10,scale=480:-1:flags=lanczos" -c:v gif output.gif
```

- fps=10: frames per second (adjust for quality/size)
- scale=480:-1: resizes width to 480px and keeps aspect ratio
