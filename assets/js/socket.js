/*
 * Setup Sockets
 */
import {Socket} from "phoenix"

let socket = new Socket("/socket", {params: {token: window.userToken}})
socket.connect()

let channel = socket.channel("room:lobby", {})
let messagesContainer = document.querySelector("#messages")

// Join the channel
channel.join()
  .receive("ok", payload => {
  })
  .receive("error", resp => {
    console.log("Unable to join", resp)
  })

// Update the ingredients when dish changes arrive on the channel
channel.on("dish", payload => {
  updateIngredients(payload)
})

/*
 * Configure the Drag and Drop features
 */
dragula([document.querySelector('#dishes'), document.querySelector('#meals')], {
  copy: true
})
.on('drop', function (card, container) {
  cardAction(card, container);
});

dragula([document.getElementById('meals')], {
  removeOnSpill: true
});

/*
 * Dynamically update the DOM based on data from the channel listeners
 */
function updateIngredients(data) {
  let ingredients = d3.select("#shopping_list")
    .selectAll("p")
    .data(data.list, (d) => (d && d.key))
    .text((d) => d.name)
    .attr('class', 'card-text text-secondary')

  ingredients.enter().append("p")
    .text((d) => d.name)
    .attr('class', 'card-text text-secondary');

  ingredients.exit().remove();
}

/*
 * Send messages to the channel based on drag and drop actions
 */
function cardAction(card, container) {
  const action = container === null ? "remove" : "add";
  channel.push("dish", dishPayload(action, card));
}
const dishPayload = (action, card) => ({action: action, id: stringId(card.id)})
const stringId = (dishString) => dishString.split("-")[1]

export default socket
