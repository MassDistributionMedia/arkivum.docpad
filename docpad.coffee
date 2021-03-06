# The DocPad Configuration File
# It is simply a CoffeeScript Object which is parsed by CSON
docpadConfig = {

	# =================================
	# Template Data
	# These are variables that will be accessible via our templates
	# To access one of these within our templates, refer to the FAQ: https://github.com/bevry/docpad/wiki/FAQ

	templateData:

		# Specify some site properties
		site:
			# The production url of our website
			url: "http://example.com"

			# Here are some old site urls that you would like to redirect from
			oldUrls: ['']

			# The default title of our website
			title: "Arkivum - Every bit archived"

			# The website description (for SEO)
			description: """
				Long term data archiving managed service 
				"""

			# The website keywords (for SEO) separated by commas
			keywords: """
				long term data storage, genomics archive, healthcare data archive, research data archive, digital heritage archive, Janet archiving, guaranteed data storage, gcloud archive, data archiving managed service, digital archive managed service, etmf archive
				"""

			# The website author's name
			author: "Mass Distribution Media"

			# The website author's email
			email: "mike@mdm.cm"

			# Styles
			styles: [
				"http://yui.yahooapis.com/pure/0.2.0/pure-min.css"
				"/styles/style.css"
			]

			# Scripts
			scripts: [
				"http://yui.yahooapis.com/3.12.0/build/yui/yui-min.js"
				"http://code.jquery.com/jquery-1.10.1.min.js"
				"/scripts/script.js"
			]
		
		moment: require 'moment'
		dateFormat: 'YYYY-MM-DD'
		# See http://momentjs.com/docs/#/displaying/format/ for options.



		# -----------------------------
		# Helper Functions

		# Get the prepared site/document title
		# Often we would like to specify particular formatting to our page's title
		# we can apply that formatting here
		getPreparedTitle: ->
			# if we have a document title, then we should use that and suffix the site's title onto it
			if @document.title
				"#{@document.title} | #{@site.title}"
			# if our document does not have it's own title, then we should just use the site's title
			else
				@site.title

		# Get the prepared site/document description
		getPreparedDescription: ->
			# if we have a document description, then we should use that, otherwise use the site's description
			@document.description or @site.description

		# Get the prepared site/document keywords
		getPreparedKeywords: ->
			# Merge the document keywords with the site keywords
			@site.keywords.concat(@document.keywords or []).join(', ')

		# Get the next four events from this week's Sunday.
		getEventsFromSunday: (limit=4) ->
			now = new Date()
			o = now.getDay() * 24 * 60 * 60 * 1000
			temp = new Date(now - o)
			lastSunday = new Date(temp.getFullYear(), temp.getMonth(), temp.getDate())
			options = 
				year: "numeric"
				month: "numeric"
				day: "numeric"
			options.timeZone = "UTC"
			options.timeZoneName = "short"
			
			events = @getCollection('events').findAll({event:{$gte:lastSunday}}).toJSON()
			if events.length > limit then events.length = limit
			
			return events


	# =================================
	# Collections
	# These are special collections that our website makes available to us

	collections:
		# Pages & Posts, default DocPad collections
		pages: (database) ->
			database.findAllLive({pageOrder: $exists: true}, [pageOrder:1,title:1])

		posts: (database) ->
			database.findAllLive({tags:$has:'post'}, [postDate:-1, date:-1])

		# Case Studies, Brochures, Whitepapers, Videos, Arkivum collections
		casestudies: (database) ->
			database.findAllLive({casestudy: $exists: true}, [casestudy:1,title:1])

		brochures: (database) ->
			database.findAllLive({brochure: $exists: true}, [brochure:1,title:1])

		whitepapers: (database) ->
			database.findAllLive({whitepaper: $exists: true}, [whitepaper:1,title:1])

		videos: (database) ->
			database.findAllLive({video: $exists: true}, [video:1,title:1])

		events: (database) ->
			database.findAllLive({event: $exists: true}, [event:1])

		news: (database) ->
			database.findAllLive({tags:$has:'news'}, [postDate:-1, date:-1])

		# Menu drop down collections
		left_sidebar_menu: (database) ->
			database.findAllLive({tags:$has:'left_sidebar_menu-item'}, [date:-1])
			.on('add', (model) ->
				#require('fs').appendFileSync 'left-sidebar.log', JSON.stringify(model) + "\n"
				urlDupe = @any (_model) ->
					return _model.get('url') is model.get('url')

				if urlDupe then return false
			)

		mobilemenu: (database) ->
			database.findAllLive({mobileMenu: $exists: true}, [mobileMenu:1,title:1])


	# =================================
	# DocPad Events

	# Here we can define handlers for events that DocPad fires
	# You can find a full listing of events on the DocPad Wiki
	events:

		# Server Extend
		# Used to add our own custom routes to the server before the docpad routes are added
		serverExtend: (opts) ->
			# Extract the server from the options
			{server} = opts
			docpad = @docpad

			# As we are now running in an event,
			# ensure we are using the latest copy of the docpad configuraiton
			# and fetch our urls from it
			latestConfig = docpad.getConfig()
			oldUrls = latestConfig.templateData.site.oldUrls or []
			newUrl = latestConfig.templateData.site.url

			# Redirect any requests accessing one of our sites oldUrls to the new site url
			server.use (req,res,next) ->
				if req.headers.host in oldUrls
					res.redirect(newUrl+req.url, 301)
				else
					next()

	# =================================
	# Plugin Configuration

	# Skip Unsupported Plugins
	# Set to `false` to load all plugins whether or not they are compatible with our DocPad version or not
	skipUnsupportedPlugins: false  # default: true

	# Enabled Plugins
	enabledPlugins: 
		# False to disable. True to enable. 
		circleeffects: false

	plugins:
		ghpages:
			deployRemote: 'origin'
			deployBranch: 'gh-pages'

		sitemap:
			cachetime: 600000
			changefreq: 'weekly'
			hostname: 'http://arkivum.com'
}


# Export our DocPad Configuration
module.exports = docpadConfig
