Karttakomponentti

var options = {
    locations: [ { lat, lon, text, title } ], // Kartalle tulevat kohteet
    // optional params
    years: [ start, end ]   // Keruukarttojen rajaus vuoden mukaan
    mapId: ""               // Näytä vain kyseisen id:n keruukartta
    keruukartat: boolean    // Jos true, niin keruukarttataso on oletuksena päällä
    imagePath: string       // Kartan ikonien latauspolku
    withBorders: boolean    // Näytetäänkö keruukarttojen reunat. Oletuksena false
    relocationOptions: {
        saveLocation: function,
        locationConfirmed: function,
        incorrectLocationConfirmed: function
    }
};

KotusMap.init('map-div', options);

// Kartalla näkyvän alueen rajat
KotusMap.getBounds()

// Uusi paikkamerkintä
KotusMap.newLocation({
    div: 'form-div-id',
    location: [62, 25], // Optional
    save: function(data) { console.log(data); },
    cancel: function() { console.log('cancel'); }
});
