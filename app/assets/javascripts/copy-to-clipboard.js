// copy-to-clipboard
function copyToClipboard(element) {
  var textarea = document.createElement('textarea');
  textarea.textContent = element;
  document.body.appendChild(textarea);

  var selection = document.getSelection();
  var range = document.createRange();
  // range.selectNodeContents(textarea);
  range.selectNode(textarea);
  selection.removeAllRanges();
  selection.addRange(range);

  document.execCommand('copy');
  selection.removeAllRanges();

  document.body.removeChild(textarea);
}