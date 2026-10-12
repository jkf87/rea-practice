const input = document.getElementById("q");
const list = document.getElementById("list");

input.addEventListener("input", async () => {
  const results = await window.notes.search(input.value);
  list.innerHTML = "";
  for (const note of results) {
    const li = document.createElement("li");
    li.textContent = note.title;
    li.addEventListener("click", () => window.notes.copy(note.id));
    list.appendChild(li);
  }
});
