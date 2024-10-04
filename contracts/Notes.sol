// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Notes {
    // Struct to represent a note
    struct Note {
        uint id;
        string content;
        address owner;
        uint createdAt;
    }

    // Array to store all the notes
    Note[] private notes;
    
    // Mapping to track owners' notes count
    mapping(address => uint) public ownerNoteCount;
    
    // Event to notify when a note is created
    event NoteCreated(uint id, string content, address indexed owner);
    
    // Event to notify when a note is updated
    event NoteUpdated(uint id, string newContent);
    
    // Event to notify when a note is deleted
    event NoteDeleted(uint id);

    // Function to create a new note
    function createNote(string memory _content) public {
        uint noteId = notes.length;
        notes.push(Note(noteId, _content, msg.sender, block.timestamp));
        ownerNoteCount[msg.sender]++;
        emit NoteCreated(noteId, _content, msg.sender);
    }

    // Function to update an existing note (only the owner can update their note)
    function updateNote(uint _noteId, string memory _newContent) public {
        require(_noteId < notes.length, "Note does not exist");
        Note storage note = notes[_noteId];
        require(note.owner == msg.sender, "You are not the owner of this note");

        note.content = _newContent;
        emit NoteUpdated(_noteId, _newContent);
    }

    // Function to delete a note (only the owner can delete their note)
    function deleteNote(uint _noteId) public {
        require(_noteId < notes.length, "Note does not exist");
        Note storage note = notes[_noteId];
        require(note.owner == msg.sender, "You are not the owner of this note");

        delete notes[_noteId];
        ownerNoteCount[msg.sender]--;
        emit NoteDeleted(_noteId);
    }

    // Function to retrieve a specific note by ID
    function getNote(uint _noteId) public view returns (uint, string memory, address, uint) {
        require(_noteId < notes.length, "Note does not exist");
        Note storage note = notes[_noteId];
        return (note.id, note.content, note.owner, note.createdAt);
    }

    // Function to get the total number of notes
    function getTotalNotes() public view returns (uint) {
        return notes.length;
    }

    // Function to get all notes created by the caller
    function getMyNotes() public view returns (Note[] memory) {
        uint totalNotes = getTotalNotes();
        uint count = ownerNoteCount[msg.sender];
        Note[] memory myNotes = new Note[](count);
        uint index = 0;

        for (uint i = 0; i < totalNotes; i++) {
            if (notes[i].owner == msg.sender) {
                myNotes[index] = notes[i];
                index++;
            }
        }
        
        return myNotes;
    }
}
