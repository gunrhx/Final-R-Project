// # Race IAT
// **A simple use of the IAT component**
define(['extensions/iat/PIcomponent'],function(IAT){

	/*IAT.addGlobal(
	{
		target1 : 'James', 
		target2 : 'Brian'
	});*/
	// ### Properties

	/**
	 * Set Properties
	 * ************************************************************************
	 */

	IAT.setProperties({
		// Activate skip block
		DEBUG: true,
		// Set images url
		images_base_url: '/implicit/user/ybalab/daniel/death1/images/', 
		trialsPerBlock: {1:20,2:20,3:20,4:40,5:20,6:20,7:40}, 
		separatorSize : '1.6em',
		canvas : {	maxWidth: 700, proportions : 0.75}
	});

	// ### Categories

	/**
	 * Set Categories
	 * ************************************************************************
	 */


	// Each category is set using a setCategory call.
	// The minimal use is setting the category `name`, and the `images`/`words` to display.

	// ##### Concept 1
	IAT.setCategory('concept1',{
		name: IAT.getGlobal().target1,
		titleSize: '1.8em',
		media: [
			{image: 'james.jpg'},
			{image: 'james1.jpg'},
			{image: 'james2.jpg'}
		]
	});

	// ##### Concept 2
	IAT.setCategory('concept2',{
		name: IAT.getGlobal().target2,
		titleSize: '1.8em',
		media: [
			{image: 'brian.jpg'},
			{image: 'brian1.jpg'},
			{image: 'brian2.jpg'}
		]
	});

	//Randomize which attribute is attribute1 
	IAT.setCategory('attribute1',{
		name: 'Pleasant',
		titleColor: '#0000FF',
		titleSize: '1.8em',
		css : {color:'#0000FF', fontSize:'1.7em'}, 
		media: [
			{word: 'Nice'},
			{word: 'Friendly'},
			{word: 'Warm'},
			{word: 'Kind'},
			{word: 'Attractive'},
			{word: 'Considerate'}
		]
	});

	// ##### Attribute 2
	IAT.setCategory('attribute2',{
		name: 'Unpleasant',
		titleColor: '#0000FF',
		titleSize: '1.8em',
		css : {color:'#0000FF', fontSize:'1.7em'}, 
		media: [
			{word: 'Nasty'},
			{word: 'Ugly'},
			{word: 'Evil'},
			{word: 'Annoying'},
			{word: 'Rude'},
			{word: 'Irritating'}
		]
	});

	// activate the player
	//IAT.play();
});