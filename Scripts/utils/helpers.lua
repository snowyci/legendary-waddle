local Helpers = {
	LogFile = "apa-log.txt",
}

function Helpers.SaveToFile(filename, data)
	local file = io.open(filename, "w")
	file:write(data)
	file:close()
end

function Helpers.InitLogf()
	local file = io.open(Helpers.LogFile, "w")
	file:close()
end

function Helpers.Logf(data, console)
	if console == nil or console == true then print(tostring(data) .. '\n') end

	local file = io.open(Helpers.LogFile, "a")

	file:write(tostring(data) .. '\n')
	file:close()
end

return Helpers
