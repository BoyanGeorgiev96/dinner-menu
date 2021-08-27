import 'js-autocomplete/auto-complete.css';
import autocomplete from 'js-autocomplete';

const autocompleteSearch = function() {
    $( document ).ready(function() {
        if (document.getElementById('search-data')){
            const ingredients = JSON.parse(document.getElementById('search-data').dataset.ingredients)
            const searchInput = document.getElementById('fridge_item_ingredient_id');

            if (ingredients && searchInput) {
                new autocomplete({
                    selector: searchInput,
                    minChars: 1,
                    source: function(term, suggest){
                        term = term.toLowerCase();
                        const choices = ingredients.map(x => x.name);
                        const matches = [];
                        for (let i = 0; i < choices.length; i++)
                            if (~choices[i].toLowerCase().indexOf(term)) matches.push(choices[i]);
                        suggest(matches);
                    },
                    onSelect(event, ingredient, item){
                        changeMeasurement(ingredient, ingredients);
                    }
                },);
            }
        }

    });

};

export { autocompleteSearch, addListenerToButton };

function changeMeasurement(ingredient, ingredients) {
    let result = ingredients.filter(obj => {
        return obj.name === ingredient
    })[0]
    if (result){
        const measurement = result.measurement;
        $('#fridge_item_measurement').remove();
        $('#fridge_item_measurement_span').remove();
        if (measurement) {
            const element = document.querySelector("#fridge_item_ingredient_quantity");
            if (measurement==="g" || measurement==="kg"){
                createMeasurementDropdown(["g","kg"]);
            }
            else if (measurement==="l" || measurement==="ml" || measurement==="cl"){
                createMeasurementDropdown(["ml", "cl", "l"]);
            }
            else{
                let $span = $( document.createElement('span') );
                $span.attr("name", "fridge_item_span[measurement]");
                $span.attr("id", "fridge_item_measurement_span");
                $span.text(measurement);
                $('#fridge_item_ingredient_quantity').after($span)

                let hiddenFieldMeasurement = document.createElement("input");
                hiddenFieldMeasurement.setAttribute("type", "hidden");
                hiddenFieldMeasurement.setAttribute("name", "fridge_item[measurement]");
                hiddenFieldMeasurement.setAttribute("id", "fridge_item_measurement");
                hiddenFieldMeasurement.setAttribute("value", measurement);
                $('#fridge_item_measurement_span').after(hiddenFieldMeasurement);
            }
        }
    }
    else
    console.log(result)
}

function createMeasurementDropdown(measurements){
    let measurementElement = document.createElement("select");
    measurementElement.name = "fridge_item[measurement]";
    measurementElement.id = "fridge_item_measurement"

    for (const measurement of measurements)
    {
        let option = document.createElement("option");
        option.value = measurement;
        option.text = measurement;
        measurementElement.appendChild(option);
    }
    $('#fridge_item_ingredient_quantity').after(measurementElement);
}
function addListenerToButton(){
    $( document ).ready(function() {
        document.querySelectorAll('.plus-button').forEach(item => {
            item.addEventListener('click', event => {
                removeHiddenField()
                $('#update_quantity_'+item.id).append('<input type="hidden" name="sign" value="plus" id="sign_hidden_field" />');
            })
        });
        document.querySelectorAll('.minus-button').forEach(item => {
            item.addEventListener('click', event => {
                removeHiddenField()
                $('#update_quantity_'+item.id).append('<input type="hidden" name="sign" value="minus" id="sign_hidden_field" />');
            })
        });
    });
}

function removeHiddenField(){
    let hidden_field = $('#sign_hidden_field');
    if (hidden_field.length>0){
        hidden_field.remove()
    }
}
