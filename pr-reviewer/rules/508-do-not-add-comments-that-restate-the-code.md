# 508: Do Not Add Comments That Restate the Code

Do not add a comment, inline or Javadoc, that says what the code next to it already says. A Javadoc that paraphrases a method's name and body, or an inline comment that walks through the next few statements, gives the reader a second copy of the logic in prose. When the code needs explaining, first try a better name or a smaller method. A comment earns its place only when it records something the code cannot show, and that is rare.

**Rationale:** A comment that restates the code doubles what the reader has to read and drifts from the code the first time the code changes, after which it misleads. `pr-reviewer/STYLE.md` lists narrating comments among the things that do not earn their place. In practice, reviewers also remove explanatory comments that a branch adds, not only literal narration, so treat a new comment as something to justify.

A violation is a comment added by the change that describes what the adjacent code does, or that explains behavior a reader learns from the code and its names, whether it is an inline comment or a Javadoc on an internal method. Do not flag a license header, a `@deprecated` or other tag with a meaning to tooling, a reference to a ticket or specification the code depends on, or a comment style the surrounding file already uses consistently [001].

**Example:** commit `07e60f65` ("Remove the comments this branch added") deleted the Javadoc and inline comments a branch had added to `UrlReader` and its test; `44fef2da` ("Remove unnecessary comments") deleted two comments that explained the right to left pointer math in `ResizableColumn` and `DragLayer`.

```diff
-	/**
-	 * Returns the client extension descriptor type. The project's own
-	 * Dockerfile, which replaces the template for its classification grouping,
-	 * makes a project that declares only configuration a service.
-	 */
 	@Internal
 	public String getDescriptorType() {
```