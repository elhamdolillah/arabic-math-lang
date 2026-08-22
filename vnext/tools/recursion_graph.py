"""محلل ساكن لرسم الاستدعاءات ومكونات الاتصال الشديد.

لا ينفذ الشيفرة المدخلة؛ وهو كاشف بنيوي لا يثبت الانتهاء وحده.
"""
from __future__ import annotations
import ast
from dataclasses import dataclass

@dataclass(frozen=True)
class CallGraph:
    functions: tuple[str, ...]
    edges: tuple[tuple[str, str], ...]
    sccs: tuple[tuple[str, ...], ...]


def _scc(nodes: list[str], edges: list[tuple[str, str]]) -> list[tuple[str, ...]]:
    adj = {n: [] for n in nodes}
    for a, b in edges:
        if a in adj and b in adj:
            adj[a].append(b)
    index = 0
    stack: list[str] = []
    on_stack: set[str] = set()
    indices: dict[str, int] = {}
    low: dict[str, int] = {}
    result: list[tuple[str, ...]] = []

    def visit(v: str) -> None:
        nonlocal index
        indices[v] = low[v] = index
        index += 1
        stack.append(v)
        on_stack.add(v)
        for w in adj[v]:
            if w not in indices:
                visit(w)
                low[v] = min(low[v], low[w])
            elif w in on_stack:
                low[v] = min(low[v], indices[w])
        if low[v] == indices[v]:
            component = []
            while True:
                w = stack.pop()
                on_stack.remove(w)
                component.append(w)
                if w == v:
                    break
            result.append(tuple(sorted(component)))

    for node in nodes:
        if node not in indices:
            visit(node)
    return result


def analyze(source: str) -> CallGraph:
    tree = ast.parse(source)
    functions = sorted(
        node.name for node in ast.walk(tree)
        if isinstance(node, (ast.FunctionDef, ast.AsyncFunctionDef))
    )
    known = set(functions)
    edges_set: set[tuple[str, str]] = set()
    for node in ast.walk(tree):
        if not isinstance(node, (ast.FunctionDef, ast.AsyncFunctionDef)):
            continue
        for child in ast.walk(node):
            if isinstance(child, ast.Call) and isinstance(child.func, ast.Name):
                if child.func.id in known:
                    edges_set.add((node.name, child.func.id))
    edges = sorted(edges_set)
    sccs = sorted(_scc(functions, edges))
    return CallGraph(tuple(functions), tuple(edges), tuple(sccs))


def cyclic_components(graph: CallGraph) -> tuple[tuple[str, ...], ...]:
    self_edges = set(graph.edges)
    return tuple(
        component for component in graph.sccs
        if len(component) > 1 or (component and (component[0], component[0]) in self_edges)
    )
