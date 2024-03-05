const NoteFactory = artifacts.require("NoteFactory");

module.exports = function (deployer) {
  deployer.deploy(NoteFactory);
};
