# Bolt's Journal

## 2025-05-14 - [Optimizing BASIC to PRG Tokenization]
**Learning:** Tokenization in Python using linear scans of large token lists and string slicing is a major bottleneck. By indexing tokens by their first character and using `str.startswith(token, index)`, we can avoid $O(N \cdot M)$ complexity and unnecessary string allocations.
**Action:** Always prefer dictionary-based lookups and indexed string operations for parsers/tokenizers in this codebase.

## 2025-05-14 - [Python Built-ins for Case Inversion]
**Learning:** Manual character-by-character loops for case inversion in Python are significantly slower than the built-in `str.swapcase()` method, which is implemented in C.
**Action:** Use Python built-in string methods (like `swapcase`, `translate`) whenever possible for bulk string transformations.
