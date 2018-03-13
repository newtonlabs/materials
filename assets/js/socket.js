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
  updateIngredients(payload);
  updatePlan(payload)
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
    .data(data.list, (d) => (d && d.key)) // TODO fix this with data api

  ingredients.enter()
    .append("p")
      .attr('class', 'card-text text-dark')
    .merge(ingredients)
      .text((d) => d.name);

  ingredients.exit().remove();
}

function updatePlan(data) {
  let dishes = d3.select("#meals")
    .selectAll("div.card")
    .data(data.dishes, function(d) {return (d && d.id) || this.dataset.dishId;});

  dishes.enter()
    .append("div")
      .attr('class', 'card border-primary mb-3')
      .attr('style', 'max-width: 18rem;')
      .attr('data-dish-id', (d) => d.id)
    .merge(dishes)
    .html(function(d) { return htmlCard(d) });

  dishes.exit().remove();
}

function htmlCard(meal) {
  let html = `
        <div class="card-body grabbable">
          <button type="button" class="close" aria-label="Close">
            <span aria-hidden="true">&times;</span>
          </button>
          <p class="card-title text-dark">${meal.name}</p>
        </div>
  `
  return html;
}
/*
 * Send messages to the channel based on drag and drop actions
 */
function cardAction(card, container) {
  const action = container === null ? "remove" : "add";
  channel.push("dish", dishPayload(action, card));
}
const dishPayload = (action, card) => ({ action: action, id: card.dataset.dishId })

/*
 * Modal stuff
 */
$('#exampleModal').on('show.bs.modal', function (event) {
  let click = $(event.relatedTarget);
  let id = click.data('dish-id');
  let modal = $(this);

  channel.push(`dish:${id}`)
    .receive("ok", (reply) => {
      modal.find('.modal-title').text(reply.name);
      modal.find('.modal-body').html(composeIngredients(reply.ingredients));
    })
})

function composeIngredients(ingredients) {
  let iStr = ingredients.reduce((acc, val) => acc + `<li>${val.name}</li>`, "")
  return `<ul>${iStr}</ul>`
}

export default socket
