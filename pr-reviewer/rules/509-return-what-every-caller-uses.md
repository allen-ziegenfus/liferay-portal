# 509: Return What Every Caller Uses

When every caller of a helper reads the same property or element from its result and uses nothing else, the helper returns that property or element instead. Move the dereference into the helper once rather than repeating it at each call site.

**Rationale:** A helper that returns a wrapper its callers immediately unwrap makes each caller know the wrapper's shape and repeats the same step at every call. Returning the value the callers want gives the helper a narrower, more honest contract, shortens each call site, and leaves one place to change if the shape changes.

A violation is a private method, or a method in a script, whose every call site immediately reads the same property, getter, key, or index from its return value, as in `_readDescriptor("able").descriptor` and `_readDescriptor("baker").descriptor`. Do not flag a helper with a caller that uses the whole result or a different part of it, or a method that is part of a public API.

**Example:** two test script helpers, `_readDescriptor` and `_pullDescriptor`, returned the parsed JSON and every caller read `.descriptor` from it, so the helpers now return the `descriptor` property.

```diff
-Map<String, Object> ableDescriptorMap = _readDescriptor("able").descriptor
+Map<String, Object> ableDescriptorMap = _readDescriptor("able")
```