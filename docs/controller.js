
function openLink(path) {
  if (window.location.origin == "file://")
    window.open("../" + path, 'rwm');
  else
    window.open("https://github.com/bwbush/real-world-marlowe/blob/main/" + path, 'rwm');
}

function setImage(img, path) {
  img.onload = ""
  if (window.location.origin == "file://")
    img.src = "../" + path
  else
    img.src = "https://raw.githubusercontent.com/bwbush/real-world-marlowe/main/" + path
}
