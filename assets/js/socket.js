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
      .attr('class', 'card-text text-dark mb-1')
    .merge(shoppingList)
      .text((d) => d.name);

  shoppingList.exit().remove();
}

function updateCardIngredients(id, card) {
  let ingredients = d3.select("#card-ingredients")
    .selectAll("li")
    .data(card.ingredients, function(d) {return (d && d.id) || this.dataset.ingredientId;})

  ingredients.enter()
    .append("li")
      .attr('class', 'list-group-item')
      .attr('data-ingredient-id', (d) => d.id)
    .merge(ingredients)
      .html((d) => ingredientText(d));

  ingredients.exit().remove();

  $('.remove-ingredient').on('click', function(e) {
    channel.push(`remove_ingredient:${id}`, {name: e.target.dataset.ingredientName})
      .receive("ok", (card) => updateCardIngredients(id, card))
  });
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
    .receive("ok", (card) => buildModal(modal, card))
})
$('#myModal').on('hide.bs.modal', function (e) {
  channel.push(`cards`)
    .receive("ok", (cards) => updateShoppingList(payload))
})

function buildModal(modal, card) {
  modal.find('.modal-dialog').html(modalTemplate(card));

  let inputIngredient = document.querySelector("#inputIngredient");
  let cardFrom = document.querySelector("#cardForm");
  let id = card.id

  inputIngredient.addEventListener("keypress", event => {
    if(event.keyCode === 13){
      channel.push("add_ingredient:" + id, {name: inputIngredient.value, card_id: id})
      .receive("ok", function(card) {
        inputIngredient.value = "";
        updateCardIngredients(id, card);
      })
    }
  })


  $('#cardSave').on('click', function (e) {
    let name = document.querySelector("#inputName").value;
    let id = document.querySelector("#cardSave").dataset.cardId;
    let description = document.querySelector("#inputSteps").value;

    let payload = {
      name: name,
      body: description
    }

    channel.push(`update_card:${id}`, payload)
      .receive("error", (card) => console.log("something broke"))
  })

  $('.remove-ingredient').on('click', function(e) {
    channel.push(`remove_ingredient:${id}`, {name: e.target.dataset.ingredientName})
      .receive("ok", (card) => updateCardIngredients(id, card))
  });
}

function modalTemplate (card) {
  return `<div class="modal-dialog modal-lg" role="document">
      <div class="modal-content">
        <div class="modal-header">
          <h5 class="modal-title" id="modal-label">Recipe Card</h5>
        </div>
        <div class="modal-body">
          <form id="cardForm">
            <div class="form-group row">
              <label for="cardName" class="col-sm-2 col-form-label">Name</label>
              <div class="col-sm-10">
                <input type="name" class="form-control" id="inputName" placeholder="Name" value="${card.name}"">
              </div>
            </div>
            <div class="form-group row">
              <label for="inputSteps" class="col-sm-2 col-form-label">Steps</label>
              <div class="col-sm-10">
                <textarea class="form-control" id="inputSteps" placeholder="Steps..." rows="7">${card.body || ""}</textarea>
              </div>
            </div>
            <fieldset class="form-group">
              <div class="row">
                <legend class="col-form-label col-sm-2 pt-0">Ingredients</legend>
                <div class="col-sm-10">
                  <ul class="list-group" id="card-ingredients">
                    ${composeIngredients(card.ingredients)}
                  </ul>
                  <input type="ingredient" class="form-control mt-2" id="inputIngredient" placeholder="Name @ location">
                </div>
              </div>
            </fieldset>
          </form>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-success float-right" data-dismiss="modal" id="cardSave" data-card-id="${card.id}">Save</button>
        </div>
      </div>
    </div>`
}

function composeIngredients(ingredients) {
  return ingredients.reduce((acc, val) => acc + ingredientTemplate(val), "")
}

function ingredientTemplate(ingredient) {
  return `
  <li class="list-group-item" data-ingredient-id="${ingredient.id}">
    ${ingredientText(ingredient)}
  </li>
  `
}

function ingredientText(ingredient) {
  return `
  <span class="badge badge-secondary">${ingredient.location}</span> ${ingredient.name}
  <button type="button" class="close remove-ingredient" aria-label="Close">
    <span aria-hidden="true" data-ingredient-name="${ingredient.name}">&times;</span>
  </button>
  `
}

export default socket
