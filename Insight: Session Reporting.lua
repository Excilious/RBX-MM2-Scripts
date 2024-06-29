-- Import services
local Support = require(script.SupportLibrary)
Support.ImportServices()

local Insight = require(ServerScriptService.Insight)

-- Extend Insight for sessions
Insight.PlayerSessions = {}

function Insight.GetSession(Player)
	-- Returns the given player's session ID

	-- Get their session data
	local Session = Insight.PlayerSessions[Player and Player.UserId]

	-- Return session ID if found
	return Session and Session.SessionId

end

Players.PlayerAdded:connect(function (Player)

	-- Generate player session ID
	Insight.PlayerSessions[Player.UserId] = {
		SessionId = HttpService:GenerateGUID(false),
		StartedAt = os.time()
	}

	-- Push join event
	Insight.QueueEvent {
		event = 'player-joined',
		timestamp = os.time(),
		sessionId = Insight.GetSession(Player),
		userId = Player.UserId,
		username = Player.Name,
		membershipType = Player.MembershipType.Name,
	}

end)

Game.Players.PlayerRemoving:connect(function (Player)

	-- Get player session
	local Session = Insight.PlayerSessions[Player.UserId]

	-- Push leave event
	Insight.QueueEvent {
		event = 'player-left',
		timestamp = os.time(),
		sessionId = Insight.GetSession(Player),
		userId = Player.UserId,
		username = Player.Name,
		membershipType = Player.MembershipType.Name,
		sessionDuration = os.time() - Session.StartedAt,
		sessionStart = Session.StartedAt,
		sessionEnd = os.time()
	}
	
	-- Clear session data
	Insight.PlayerSessions[Player.UserId] = nil

end)
