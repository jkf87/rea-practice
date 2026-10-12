const { app, BrowserWindow, ipcMain, clipboard } = require("electron");
const path = require("node:path");
const { searchNotes } = require("./search");
const store = require("./store");

function createWindow() {
  const win = new BrowserWindow({
    width: 900,
    height: 640,
    webPreferences: { preload: path.join(__dirname, "preload.js"), contextIsolation: true },
  });
  win.loadFile(path.join(__dirname, "renderer", "index.html"));
}

ipcMain.handle("notes:search", (_event, query) => searchNotes(store.all(), query));
ipcMain.handle("notes:copy", (_event, id) => {
  const note = store.get(id);
  clipboard.writeText(`${note.title}\n\n${note.body}`);
  return true;
});

app.whenReady().then(createWindow);
