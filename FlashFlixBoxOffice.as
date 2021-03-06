﻿package
{
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.SharedObject;
	
	import FlashFlix_Group2Proj;
	
	public class FlashFlixBoxOffice extends MovieClip
	{
		public static const NUMBER_OF_MOVIES: int = 50;
		
		//var url: String;
		//var urlLoader: URLLoader = new URLLoader();
		var my_loader: Loader = new Loader();
		
		var movieDisplay: MovieClip;
		var movieBio: MovieClip;
		var rightButton:SimpleButton;
		var leftButton:SimpleButton;
		
		var movieArray: Array = [];
		var loadedArray: Array = new Array();
		var counter: int = 0;
		var movieObject: MovieClip;
		var startNumber:int = 4;
		var manager:FlashFlix_Group2Proj;
		var diswatch:diswatch_btn = new diswatch_btn;
		var mySharedObject:SharedObject = SharedObject.getLocal("flashflix");

		var criticStarChart:MovieClip;
		var audiStarChart:MovieClip;
				
		
		public function FlashFlixBoxOffice(proj:FlashFlix_Group2Proj)
		{
			manager = proj;
			var ydistance = 550;
			movieDisplay = new movieDisplay_mc;
			//movieDisplay.x = 0;
			movieDisplay.y = 260;
			addChild(movieDisplay);
			movieBio = new movieBio_mc;
			movieBio.x = 0;
			movieBio.y = 600;
			addChild(movieBio);
			
			movieBio.criticStars.gotoAndStop(1);
			movieBio.audiStars.gotoAndStop(1);
			
			movieBio.criticStars.visible=false;
			movieBio.audiStars.visible = false;
			
			leftButton = new leftButton_mc();
			leftButton.y = ydistance;
			addChild(leftButton);
			leftButton.addEventListener(MouseEvent.CLICK, scrollLeft);
			rightButton = new rightButton_mc();
			rightButton.x = 1250;
			rightButton.y = ydistance;
			addChild(rightButton);
			rightButton.addEventListener(MouseEvent.CLICK, scrollRight);
			//addChild(rightButton);
			//movieDisplay = FlashFlix_Group2Proj.homestage;
			loadConfigFromUrl();
		}
						
		public function loadConfigFromUrl(): void {
			var urlRequest: URLRequest = new URLRequest("http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?apikey=6psypq3q5u3wf9f2be38t5fd&limit=" + NUMBER_OF_MOVIES+"&nocache=" + new Date().getTime());
			//var urlRequest: URLRequest = new URLRequest("http://api.rottentomatoes.com/api/public/v1.0/lists/movies/upcoming.json?apikey=6psypq3q5u3wf9f2be38t5fd&nocache=" + new Date().getTime());
			var urlLoader: URLLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, completeHandler);
			
			try {
				urlLoader.load(urlRequest);
			} catch (error: Error) {
				trace("Cannot load : " + error.message);
			}
		}
		
		public function scrollRight(event:Event){
			if(-(movieDisplay.x - 1400) < (NUMBER_OF_MOVIES * (movieObject.width + 19)))
			{
				movieDisplay.x -=300;
			}

			
		}
		
		public function scrollLeft(event:Event){
			if(movieDisplay.x < 0)
			{
			movieDisplay.x +=300;
			}		
		}
		
		public function completeHandler(event: Event): void {
			var stringJSON: String;
			stringJSON = String(event.target.data);
			//trace(stringJSON);
			//trace(stringJSON);
			
			//var loader: URLLoader = URLLoader(event.target);
			//trace("completeHandler: " + loader.data);
			
			var data: Object = JSON.parse(stringJSON);
			//trace(data);
			//trace("The movie title is: " + data.movies[0].title + ", Rated: " + data.movies[0].mpaa_rating + " Critic's Score: " + data.movies[0].ratings.critics_score + " Audience Score: " + data.movies[0].ratings.audience_score + ", Image: " + data.movies[0].posters.profile);
			//trace("The movie title is: " + data.movies[1].title + ", Rated: " + data.movies[0].mpaa_rating + " Critic's Score: " + data.movies[1].ratings.critics_score + ", Image: " + data.movies[0].posters.profile);
			//All fields from JSON are accessible by theit property names here/
						
			for (var i: int = 0; i < NUMBER_OF_MOVIES; i++) {
				movieObject = new movieObject_mc;
				movieArray[i] = movieObject;
				movieArray[i].movieid = data.movies[i].id;
				movieArray[i].movieTitle = data.movies[i].title;
				movieArray[i].smallMovieCover = data.movies[i].posters.profile;
				movieArray[i].largeMovieCover = data.movies[i].posters.detailed;
				movieArray[i].criticScore = data.movies[i].ratings.critics_score;
				movieArray[i].criticConsensus = data.movies[i].critics_consensus;
				//movieArray[i].criticConsensus = data.movies[i].critics_consensus;
				movieArray[i].audienceScore = data.movies[i].ratings.audience_score;
				movieArray[i].releaseDate = data.movies[i].release_dates.theater;
				movieArray[i].mpaaRating = data.movies[i].mpaa_rating;
				movieArray[i].runtime = data.movies[i].runtime;
				movieArray[i].cast = "";
								movieArray[i].disWatch = movieObject.diswatch2_btn;
				movieArray[i].disWatch.addEventListener(MouseEvent.CLICK, switchDelete);
				if(mySharedObject.data.diswatches == null || mySharedObject.data.diswatches == false)
				movieArray[i].disWatch.visible = false;
				movieArray[i].disLike = movieObject.dislike2_btn;
				if(mySharedObject.data.dislikes == null || mySharedObject.data.dislikes == false)
				movieArray[i].disLike.visible = false;
				movieArray[i].disLike.addEventListener(MouseEvent.CLICK, switchDelete);

				//movieArray[i].theaterDate = data.movies[i].release_dates.theater.slice(0,4);

				//trace(data.movies[i].abridged_cast.length);
				for(var j:int = 0;j < data.movies[i].abridged_cast.length; j++)
				{
					movieArray[i].cast += data.movies[i].abridged_cast[j].name + ", ";
				}
				
				movieObject.x = 20+(19 + movieObject.width) * i;
				movieObject.y = 100;
				//movieDisplay.x = 20+(19 + movieObject.width) * i;
				movieDisplay.y = 10;
				my_loader.load(new URLRequest(movieArray[i].smallMovieCover));
				movieDisplay.addChild(movieObject);
				movieArray[i].addEventListener(MouseEvent.CLICK, movieClick);
				movieArray[i].watch_btn.addEventListener(MouseEvent.CLICK, alreadyWatched);
				movieArray[i].want_btn.addEventListener(MouseEvent.CLICK, wantToWatch);
				//movieObject.addChild(my_loader);
				MovieManager.getInstance().addComingSoonCache(movieArray[i].movieid, movieArray[i]);
			}
						
			loadImage();
			/*my_loader.load(new URLRequest(movieArray[0].poster));
			my_loader2.load(new URLRequest(movieArray[1].poster));
			homePage.addChild(my_loader);
			homePage.addChild(my_loader2);*/
		}
		
		function loadImage(): void {
			var loader: Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loaded);
			loader.load(new URLRequest(movieArray[counter].smallMovieCover));
		}
		
		function loaded(e: Event): void {
			
			loadedArray.push(e.target.content);
			
			if (counter == movieArray.length - 1) {
				
				for (var i: uint = 0; i < loadedArray.length; i++) {
					loadedArray[i].x = 0;
					loadedArray[i].y = 200;
					movieArray[i].addChild(loadedArray[i]);
				}
			} else {
				counter++;
				loadImage();
			}
		}
		
		public function switchDelete(e:Event){
			trace(e.target.parent.movieTitle);
			if(e.target.name == "dislike2_btn"){
				mySharedObject.data.dislikes = false;
				mySharedObject.flush();
				MovieManager.getInstance().deleteMovie('hasWatched', e.target.parent.movieid);
			}
			else if(e.target.name == "diswatch2_btn"){
				mySharedObject.data.diswatches = false;
				mySharedObject.flush();
				MovieManager.getInstance().deleteMovie('wantToWatch',e.target.parent.movieid);
			}
			e.target.visible = false;
			
		}

		
		function passOMDB(movieName:String, theaterDate:String)
		{
			
			var urlRequest: String = "http://www.omdbapi.com/?t="+movieName+"&y="+theaterDate;
			var loader: URLLoader = new URLLoader();
			
			try
			{
				loader.load(new URLRequest(urlRequest));
				loader.addEventListener(Event.COMPLETE, loadingOMBDData);
			}
			catch(error:Error)
			{
				trace("Cannot load : " + error.message);
			}
		}

		function loadingOMBDData(e:Event):void
		{
			var stringJSON: String;
			stringJSON = String(e.target.data);
			
			var data: Object = JSON.parse(stringJSON);
			
			trace(stringJSON);
			
			if(data.Metascore != "" || data.Metascore != null)
			{
				trace(data.Metascore);
				if(!data.Metascore)
				{
					trace("Error");
					movieBio.metaScore.text = "Metacritic score: N/A";
					movieBio.imdbScore.text = "IMDB Score: N/A";
				}
				else
				{
					movieBio.metaScore.text = "Metacritic score: " + data.Metascore;
					movieBio.imdbScore.text = "IMDB Score: " + data.imdbRating;
				}
			}
		}
		
		public function movieClick(e:Event): void {
			//trace(e.target.movieTitle);
			//trace(e.target.largeMovieCover);
			MovieManager.getInstance();
			my_loader.load(new URLRequest(e.target.largeMovieCover));
			
			passOMDB(e.target.movieTitle, e.target.releaseDate.slice(0,4));
			
			movieBio.movieTitle.text = e.target.movieTitle + " ("+ e.target.releaseDate + ")";
			movieBio.criticsConsensus.text = e.target.criticConsensus;			movieBio.criticScore.text = "Critic Score: "+e.target.criticScore+"%";
			movieBio.audienceScore.text = "Audience Score: "+e.target.audienceScore+"%";
			movieBio.mpaaRating.text = e.target.mpaaRating;
			movieBio.runtime.text = e.target.runtime+" minutes";
			
			
			movieBio.criticStars.visible = true;
			movieBio.audiStars.visible = true;
			
			movieBio.criticStars.gotoAndStop(e.target.criticScore);
			movieBio.audiStars.gotoAndStop(e.target.audienceScore);
			
			
			my_loader.x = 50;
			my_loader.y = 40;
			movieBio.addChild(my_loader);
		}
		
		public function wantToWatch(e:Event):void {
			trace("I want to watch this");
						mySharedObject.data.dislikes = true;
			e.target.parent.disLike.visible = true;
			mySharedObject.flush();
			//trace(e.target.parent.smallMovieCover);

			MovieManager.getInstance().addMWantWatch(manager.getUserID(), e.target.parent);
			//MovieManager.getInstance().updateWantToWatch(manager.getUserID(), e.target.parent.movieid, 'wantToWatch');
			//MovieManager.getInstance().addMWantWatch(manager.getUserID(), e.target.parent.movieid);
		}
		public function alreadyWatched(e:Event):void{
			trace("I've already watched this, lets rate it");
						mySharedObject.data.diswatches = true;
			mySharedObject.flush();
			e.target.parent.disWatch.visible = true;
			MovieManager.getInstance().addMWatched(manager.getUserID(),e.target.parent);

			MovieManager.getInstance().addMWatched(manager.getUserID(),e.target.parent.movieid);
		}
	}
}