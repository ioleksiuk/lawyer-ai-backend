// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DocumentSigner {
    // Event to emit when a document is signed
    event DocumentSigned(address indexed signer, bytes32 documentHash);

    // Structure to hold document signature information
    struct Document {
        bytes32 hash;
        address signer1; // The creator of the document
        address signer2; // The second signer specified by the creator
        bool signedBySigner1; // Indicates if the document is signed by the first signer
        bool signedBySigner2; // Indicates if the document is signed by the second signer
    }

    // Mapping from document hash to its signing information
    mapping(bytes32 => Document) public documents;

    // Function to create a document and specify the second signer
    function createDocument(bytes32 _documentHash, address _signer2) public {
        require(documents[_documentHash].hash == 0, "Document already exists");
        documents[_documentHash] = Document({
            hash: _documentHash,
            signer1: msg.sender, // The creator is the first signer
            signer2: _signer2, // Specified second signer
            signedBySigner1: false,
            signedBySigner2: false
        });

        emit DocumentSigned(msg.sender, _documentHash);
    }

    // Function for a signer to sign the document
    function signDocument(bytes32 _documentHash) public {
        require(documents[_documentHash].hash != 0, "Document not initiated");
        Document storage doc = documents[_documentHash];

        if(msg.sender == doc.signer1 && !doc.signedBySigner1) {
            doc.signedBySigner1 = true;
            emit DocumentSigned(msg.sender, _documentHash);
        } else if(msg.sender == doc.signer2 && !doc.signedBySigner2) {
            doc.signedBySigner2 = true;
            emit DocumentSigned(msg.sender, _documentHash);
        } else {
            revert("Caller cannot sign or has already signed");
        }
    }

    // Function to check if a document is fully signed
    function isDocumentFullySigned(bytes32 _documentHash) public view returns (bool) {
        Document storage doc = documents[_documentHash];
        return doc.signedBySigner1 && doc.signedBySigner2;
    }
}
