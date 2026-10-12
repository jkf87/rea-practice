// 제목은 3점, 본문은 1점. 여러 단어는 모두 들어 있어야 결과에 나온다.
function scoreNote(note, words) {
  let score = 0;
  for (const w of words) {
    const inTitle = note.title.toLowerCase().includes(w);
    const inBody = note.body.toLowerCase().includes(w);
    if (!inTitle && !inBody) return 0;
    score += (inTitle ? 3 : 0) + (inBody ? 1 : 0);
  }
  return score;
}

function searchNotes(notes, query) {
  const words = query.trim().toLowerCase().split(/\s+/).filter(Boolean);
  return notes
    .map((note) => ({ note, score: scoreNote(note, words) }))
    .filter((r) => r.score > 0)
    .sort((a, b) => b.score - a.score)
    .map((r) => r.note);
}

module.exports = { searchNotes, scoreNote };
