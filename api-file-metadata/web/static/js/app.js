// Brunch automatically concatenates all files in your
// watched paths. Those paths can be configured at
// config.paths.watched in "brunch-config.js".
//
// However, those files will only be executed if
// explicitly imported. The only exception are files
// in vendor, which are never wrapped in imports and
// therefore are always executed.

// Import dependencies
//
// If you no longer want to use a dependency, remember
// to also remove its path from "config.paths.watched".
import "phoenix_html"
import $ from "jquery"

// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".

// import socket from "./socket"
// console.log($("#search_file"));
$("#search_file").change(function(){
  let fileName = "Choose File"; // default value
  let value = $(this).val();
  let messageBox = $(".message")
  if (value) {
    fileName = value.replace(/^.*fakepath\\(.*)$/, '$1')
    messageBox.css("font-weight", "bolder")
  } else {
    messageBox.css("font-weight", "normal")
  }
  messageBox.html(fileName)
})
