import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";


const Notes = buildModule("NotesModule", (m) => {
  const Note = m.contract("Notes", []);
  return { Note };
});

export default Notes;