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

// Update the ingredients when card changes arrive on the channel
channel.on("cards", payload => {
  updateShoppingList(payload);

  // TODO Make this smarter
  // updateSections(payload.sections[0])
  // updateSections(payload.sections[1])
})

/*
 * Configure the Drag and Drop features
 */
dragula([document.querySelector('#recipe-box'), document.querySelector('#this-week')])
.on('drop', function (card, container) { cardAction(card, container); });

/*
 * Dynamically update the DOM based on data from the channel listeners
 */
function updateShoppingList(data) {
  let shoppingList = d3.select("#shopping-list")
    .selectAll("p")
    .data(data.shopping_list, (d) => (d && d.key)) // TODO fix this with data api

  shoppingList.enter()
    .append("p")
      .attr('class', 'card-text text-dark')
    .merge(shoppingList)
      .text((d) => d.name);

  shoppingList.exit().remove();
}

function updateSections(data) {
  // debugger;
  // let thisWeek = d3.select("#this-week")
  // let id = 1;
  // let select = `[data-section-id='${id}']`;
  // let thisWeek = d3.select(select);
  // console.log(thisWeek);
  // let thisWeek = d3.select("[data-section-id='2']")
  //   .selectAll("div.card")
  //   .data(data.cards, function(d) {return (d && d.id) || this.dataset.cardId;});
  //
  // thisWeek.enter()
  //   .append("div")
  //     .attr('class', 'card border-primary mb-1')
  //     .attr('style', 'max-width: 18rem;')
  //     .attr('data-card-id', (d) => d.id)
  //   .merge(thisWeek)
  //   .html(function(d) { return htmlCard(d) });
  //
  // thisWeek.exit().remove();
}

function htmlCard(card) {
  return `
    <div class="card-body grabbable">
      <p class="card-title text-dark">${card.name}</p>
    </div>
  `
}
/*
 * Send messages to the channel based on drag and drop actions
 */
function cardAction(card, container) {
  let cardId = card.dataset.cardId;
  let sectionId = container.dataset.sectionId;

  channel.push("section:" + sectionId, {card_id: cardId})
}

/*
 * Modal stuff
 */
$('#exampleModal').on('show.bs.modal', function (event) {
  let click = $(event.relatedTarget);
  let id = click.data('card-id');
  let modal = $(this);

  channel.push(`cards:${id}`)
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
