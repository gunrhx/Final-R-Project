/* The script wrapper */
define(['app/API'], function(API) {

	API.addGlobal(
	{
/*		target1:"James", 
		target2:"Brian", 
		target1Image:"jamesusa.jpg", 
		target2Image:"brianusa.jpg", 
		target1Location:"the USA", 
		target2Location:"the USA", 
		target1Where:" in his home (in ", 
		target2Where:" in his home (in ", 
		target1State:"lives", 
		target2State:"died last week", 
*/
		itiDuration:1000, bvDuration:5000
	});

	API.addSettings('canvas',{
		maxWidth: 800,
		proportions : 0.72,
		background: '#ecede8',
		borderWidth: 1,
		canvasBackground: '#ffffff',
		borderColor: '#ecede8'
	});
	//the source of the images
	API.addSettings('base_url',{
		image : '/user/bvs/images/'
	});

	API.addMediaSets('goodBvs', 
	[
		{word : "Helped an elderly man who dropped some packages"}, 
		{word : "Usually smiles at people he passes on the sidewalk"}, 
		{word : "Volunteers to visit terminally ill children in the hospital twice a month"}, 
		{word : "Occasionally works overtime for no extra pay in order to do a good job"}, 
		{word : "Brings fresh bagels to everyone at work every morning"}, 
		{word : "Brought a blanket and hot meal to a homeless person"}, 
		{word : "Threw a surprise party for a friend"}, 
		{word : "Always makes people laugh when he notices that they are sad"}, 
		{word : "Took his younger brother to a movie"}, 
		{word : "Mailed back an expensive item that was delivered to him by mistake"}
	]);

	API.addMediaSets('badBvs', 
	[
		{word : "Got drunk and insulted everybody at a cocktail party"}, 
		{word : "Likes to pick fights with people that are physically weaker than him"}, 
		{word : "Threw a rock at a dog that was barking"}, 
		{word : "Smoked on a crowded bus"}, 
		{word : "Became upset and broke some dishes"}, 
		{word : "Shoplifted an inexpensive item from a store"}, 
		{word : "Embarrassed a friend by playing a prank on him"}, 
		{word : "Yelled at his parents over the phone"}, 
		{word : "Insulted his assistant at work"}, 
		{word : "Drove through a red light at a potentially dangerous intersection"}
	]);	
	
	API.addMediaSets('neuBvs', 
	[
		{word : "Watched TV before falling asleep"},
		{word : "Has an early lunch on Mondays"},
		{word : "Purchased a new mobile phone last month"},
		{word : "Read the newspaper while eating dinner"},
		{word : "Drinks orange juice with his breakfast"},
		{word : "Listened to a new song that was playing on the radio"},
		{word : "Almost forgot where he parked his car"},
		{word : "Often goes for a walk on the weekend"},
		{word : "Always eats eggs for breakfast"},
		{word : "Shaved before taking a shower"}
	]);

	//API.addMediaSets('target1Name', [{word : API.getGlobal().target1}]);
	//API.addMediaSets('target2Name', [{word : API.getGlobal().target2}]);
	API.addMediaSets('target1Name', [{inlineTemplate : '<span><%= global.target1 %></span>'}]);
	API.addMediaSets('target2Name', [{inlineTemplate : '<span><%= global.target2 %></span>'}]);

	API.addMediaSets('target1Image', [{image : API.getGlobal().target1Image}]);
	API.addMediaSets('target2Image', [{image : API.getGlobal().target2Image}]);
	
	// Create a stimulus set with the default style for all trials.
	API.addStimulusSets('default',[
		{css:{fontSize:'2em',color:'#000000'}}
	]);

	// The behavior trial.
	API.addTrialSets('bv',
	[{
		//Inputs for skipping.
		input: [
			{handle:'ykey',on:'keypressed', key:'y'} //Start only with the "skip" input
		],
		interactions: [
		{ // begin trial
			conditions: [{type:'begin'}],
			actions: [
				{type:'showStim',handle:'All'}, 
				{type:'setInput',input:{handle:'bvOut',on:'timeout',duration:API.getGlobal().bvDuration}}
			] //Show the instructions
		},
		{
			conditions: [{type:'inputEquals',value:'bvOut'}],
			actions: [
				{type:'hideStim',handle:'All'}, 
				{type:'setInput',input:{handle:'endTrial',on:'timeout',duration:API.getGlobal().itiDuration}}
			]
		}, 
		// skip block -> if you press 'b' after pressing 'y'.
		{
			conditions: [{type:'inputEquals',value:'ykey'}],
			actions: [
				{type:'setInput',input:{handle:"bkey",on: 'keypressed', key:'b'}}
			]
		},
		// skip block -> if you press 'b' after pressing 'y'.
		{
			conditions: [{type:'inputEquals',value:'bkey'}],
			actions: [
				{type:'goto', destination: 'nextWhere', properties: {blockStart:true}},
				{type:'endTrial'}
			]
		},
		{
			conditions: [{type:'inputEquals',value:'endTrial'}],
			actions: [
				{type:'endTrial'}				
			]
		}]
	}]);
	function getBVTrial(inTargetName, inTargetImage, inBVset)
	{
		var theTrial = 
		{
			inherit : 'bv', 
			stimuli : 
			[
				{
					inherit : 'default' , 
					location : {top:2},
					media : {inherit : inTargetName}
				},
				{
					inherit : 'default' , 
					location : {top:10},
					media : {inherit : inTargetImage}
				},
				{
					inherit : 'default' , 
					location : {top:37},
					media : {inherit : {set:inBVset, type:'exRandom'}}
				}
			]		
		};
		
		return(theTrial);
	}
	
	API.addTrialSets('target1Trial',
	[
		getBVTrial('target1Name', 'target1Image', 'goodBvs'), 
		getBVTrial('target1Name', 'target1Image', 'badBvs'), 
		getBVTrial('target1Name', 'target1Image', 'neuBvs')
	]);
	API.addTrialSets('target2Trial',
	[
		getBVTrial('target2Name', 'target2Image', 'goodBvs'), 
		getBVTrial('target2Name', 'target2Image', 'badBvs'), 
		getBVTrial('target2Name', 'target2Image', 'neuBvs')
	]);
	
	API.addTrialSets('inst',{
		input: [
			{handle:'space',on:'space'}
		],
		interactions: [
			{ // begin trial
				conditions: [{type:'begin'}],
				actions: [{type:'showStim',handle:'All'}] //Show the instructions
			},
			{
				conditions: [{type:'inputEquals',value:'space'}], //What to do when space is pressed
				actions: [
					{type:'hideStim',handle:'All'}, //Hide the instructions
					{type:'setInput',input:{handle:'endTrial', on:'timeout',duration:500}} //In 500ms: end the trial. In the mean time, we get a blank screen.
				]
			},
			{
				conditions: [{type:'inputEquals',value:'endTrial'}], //What to do when endTrial is called.
				actions: [
					{type:'endTrial'} //End the trial
				]
			}
		]
	});
	API.addTrialSets('instEnter',{
		input: [
			{handle:'enter',on:'enter'}
		],
		interactions: [
			{ // begin trial
				conditions: [{type:'begin'}],
				actions: [{type:'showStim',handle:'All'}] //Show the instructions
			},
			{
				conditions: [{type:'inputEquals',value:'enter'}], //What to do when space is pressed
				actions: [
					{type:'hideStim',handle:'All'}, //Hide the instructions
					{type:'setInput',input:{handle:'endTrial', on:'timeout',duration:500}} //In 500ms: end the trial. In the mean time, we get a blank screen.
				]
			},
			{
				conditions: [{type:'inputEquals',value:'endTrial'}], //What to do when endTrial is called.
				actions: [
					{type:'endTrial'} //End the trial
				]
			}
		]
	});

	var lastDetailsTarget1 = API.getGlobal().target1 + ' ' + API.getGlobal().target1State + API.getGlobal().target1Where + API.getGlobal().target1Location + ')';
	var lastDetailsTarget2 = API.getGlobal().target2 + ' ' + API.getGlobal().target2State + API.getGlobal().target2Where + API.getGlobal().target2Location + ')';
	
	var instStart = '<div><p style="font-size:18px; text-align:left; margin-left:10px; font-family:arial; color:black"><br/>';
	var instEnd = '</p></div>';
	var instContent = 
		'In the next couple of minutes, you will read about typical behaviors of the two men presented below (the flags represent their nationality).<br/>' +
		'We will show you six behaviors of each person. ' + 
		'Each behavior will appear for 5 seconds, and will be replaced by the next behavior. ' +
		'Do not press any key during the presentation of the behaviors. ' + 
		'Only try to remember which behaviors each of these two men displayed.<br/><br/>' + 
		'This part of the study will take less than 90 seconds. ' + 
		'When you are ready to begin, press space.';
	// Create the sequence.
	API.addSequence([
		{
			inherit:'inst',
			// Stimuli know to inherit from stimulus sets.
			stimuli: [
				{
					location : {left:0, top:0}, 
					media :{html:instStart+instContent+instEnd}
				},
				{
					location : {left:2, bottom:8}, 
					media : {inherit : 'target1Image'}
				},
				{
					location : {right:2, bottom:8}, 
					media : {inherit : 'target2Image'}
				},
				{
					inherit : 'default',
					location : {left:2, bottom:1}, 
					media : {inherit : 'target1Name'}
				},
				{
					inherit : 'default',
					location : {right:2, bottom:1}, 
					media : {inherit : 'target2Name'}
				}
			]
		},
		{
			mixer : 'repeat',
			times : 6,
			data : [ 
				{inherit : 'target1Trial'}, 
				{inherit : 'target2Trial'} 
			]
		},
		{
			inherit:'inst',
			data : {blockStart : true},
			// Stimuli know to inherit from stimulus sets.
			stimuli: [
			{
				inherit:'default',
				media :{word:'Press space to read biographical information about the two men'}
			}]
		},
		{
			inherit:'instEnter',
			// Stimuli know to inherit from stimulus sets.
			stimuli: [
				{
					inherit:'default',
					location : {top:5},
					media :{word:lastDetailsTarget1}
				}, 
				{
					location : {top:13}, 
					media : {inherit : 'target1Image'}
				},
				{
					inherit:'default',
					location : {top:42},
					media :{word:lastDetailsTarget2}
				}, 
				{
					location : {top:50}, 
					media : {inherit : 'target2Image'}
				},
				{
				inherit:'default',
				location : {bottom:5}, 
				media :{word:'Press enter to continue'}
				}
			]
		},
		{
			inherit:'inst',
			// Stimuli know to inherit from stimulus sets.
			stimuli: [
				{
					location : {top:1},
					css : {'text-align':'left', color:'red', fontSize:'1em'},
					inherit:'default',
					media :{word:'Memorize the biographical information about the two men, and then press space to continue to the next task.'}
				},
				{
					inherit:'default',
					location : {top:15},
					media :{word:lastDetailsTarget1}
				}, 
				{
					location : {top:23}, 
					media : {inherit : 'target1Image'}
				},
				{
					inherit:'default',
					location : {top:55},
					media :{word:lastDetailsTarget2}
				}, 
				{
					location : {top:63}, 
					media : {inherit : 'target2Image'}
				},
			]
		}
	]);

	API.addSettings('base_url',{
		image : '/implicit/user/ybalab/daniel/death1/images/'
	});
	API.addSettings('logger',{
		pulse: 20,
		url : '/implicit/PiPlayerApplet'
	});
	//What to do at the end of the task.
	API.addSettings('hooks',{
		endTask: function()
		{
			// report to the server (also use that to report the task conditions: categorization task, response deadline)
			$.post("/implicit/scorer", JSON.stringify(
				{
					target1:API.getGlobal().target1, 
					target2:API.getGlobal().target2, 
					target1Location:API.getGlobal().target1Location, 
					target2Location:API.getGlobal().target2Location, 
					target1Where:API.getGlobal().target1Where, 
					target2Where:API.getGlobal().target2Where, 
					target1State:API.getGlobal().target1State, 
					target2State:API.getGlobal().target2State
				}
			)).always(function()
			{
				//Continue to the next task
				top.location.href = "/implicit/Study?tid="+xGetCookie("tid");
			});
		}
	});

	//API.play();
});
