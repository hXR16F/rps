:: Programmed by hXR16F
:: hXR16F.ar@gmail.com, https://github.com/hXR16F

@echo off
setlocal EnableDelayedExpansion
for /f "tokens=4-5 delims=. " %%i in ('ver') do set windows_version=%%i.%%j
if "%windows_version%" equ "10.0" call :cl
rem if /i "%1" equ "--offline" set "offline=true"
color 07

:select
	if exist data.txt del /f /q data.txt >nul
	if exist srv.txt del /f /q srv.txt >nul
	if not "%offline%" equ "true" (
		for /f "tokens=*" %%i in ('dir /b') do (
			set "name=%%i"
			if "!name:~0,10!" equ "$ptnio_rps" del /f /q "%%i"
		)
	)
	set points=0
	cls
	echo Rock, Paper, Scissors
	echo.
	echo   %fg`black%Programmed by hXR16F%`r%
	echo   %fg`black%https://github.com/hXR16F%`r%
	echo.
	echo Select mode:
	echo.
	echo   %fg`white%1%`r% %fg`black%-%`r% %fg`red%Singleplayer%`r%
	echo   %fg`white%2%`r% %fg`black%-%`r% %fg`yellow-%Multiplayer%`r% %fg`black%^(hotseat^)%`r%
	if not "%offline%" equ "true" echo   %fg`white%3%`r% %fg`black%-%`r% %fg`yellow-%Multiplayer%`r% %fg`black%^(tcp/ip^)%`r%
	echo   %fg`white%x%`r% %fg`black%-%`r% %fg`white%Exit%`r%
	echo.

	set /p "choice=-> "

	if "%choice%" equ "1" (
		goto :singleplayer
	) else if "%choice%" equ "2" (
		goto :multiplayer-hotseat
	) else if "%choice%" equ "3" (
		if not "%offline%" equ "true" (
			goto :multiplayer-tcpip
		)
	) else if "%choice%" equ "x" (
		echo.
		echo   %fg`black%Thank you for playing my game.%`r%
		echo.
		timeout 1000
		exit
	)
	
	goto :select

:multiplayer-tcpip
	set ptnio_id=rps_%random%%time:~9,2%
	ptnio -id:%ptnio_id% -n -t:16
	echo.
	echo   %fg`white%1%`r% %fg`black%-%`r% %fg`red%Host game%`r%
	echo   %fg`white%2%`r% %fg`black%-%`r% %fg`yellow-%Join game%`r%
	echo.
	set /p "tcpip-choice=-> "

	if "%tcpip-choice%" equ "1" (
		goto :multiplayer-tcpip-host
	) else if "%tcpip-choice%" equ "2" (
		goto :multiplayer-tcpip-join
	) else goto :select

	:multiplayer-tcpip-host
		set is_server=true
		ipconfig | findstr /C:"IPv4 Address. . . . . . . . . . . :" > "%temp%\int_ip"
		for /f "tokens=2* delims=:" %%a in (%temp%\int_ip) do (
			set "tempint=%%a"
			set "int_ip=!tempint:~1,15!"
		)
		if exist "%temp%\int_ip" del /f /q %temp%\int_ip >nul

		echo.
		echo Server started, listening on %fg`red%%int_ip%:19900%`r%.
		
		for %%a in (
			"new listener"
			"bind listener 0.0.0.0 19900"
			"listen listener 1"
			"accept listener s"
		) do (ptnio -id:%ptnio_id% -c %%~a >nul || pause)
		goto :multiplayer-tcpip-connect
	
	:multiplayer-tcpip-join
		set is_server=false
		echo.
		echo Enter server address to join:
		echo.
		set /p "multiplayer-tcpip-ip=-> "

		echo %multiplayer-tcpip-ip%> "srv.txt"

		for /f "tokens=1,2 delims=:" %%a in (srv.txt) do (
			set "server_ip_raw=%%a"
			set "server_port=%%b"
		)

		for /f "tokens=2 delims= " %%i in ('ping -n 1 !server_ip_raw!') do (
			set "server_ip=%%i"
			goto :break_loop
		)
		:break_loop

		for %%a in (
			"new s"
			"connect s %server_ip% %server_port%"
		) do (ptnio -id:%ptnio_id% -c %%~a >nul || (
			echo.
			echo %fg`red%Failed to connect.%`r%
			timeout 3000
			goto :select
		))
		echo.
		goto :multiplayer-tcpip-connect

	:multiplayer-tcpip-connect
		set "points_one=0"
		set "player_one_nickname=%computername%"
		echo | set /p ".=%fg`yellow-%Waiting for second player... %`r%"

		echo %is_public% | ptnio -id:%ptnio_id% -c nms_send s
		for /f "tokens=*" %%a in ('ptnio -id:%ptnio_id% -c nms_recv s') do set is_public2=%%a
		set is_public2=%is_public2: =%
		echo %player_one_nickname% | ptnio -id:%ptnio_id% -c nms_send s
		for /f "tokens=*" %%a in ('ptnio -id:%ptnio_id% -c nms_recv s') do set player_two_nickname=%%a
		set player_two_nickname=%player_two_nickname: =%
		echo %points_one% | ptnio -id:%ptnio_id% -c nms_send s
		for /f "tokens=*" %%a in ('ptnio -id:%ptnio_id% -c nms_recv s') do set points_two=%%a
		set points_two=%points_two: =%

		echo %player_two_nickname% %fg`black%^($ptnio_%ptnio_id%^)%`r%
		timeout 3000
		
		:multiplayer-tcpip-connect-loop
			cls
			echo Your turn:
			echo.
			if "%is_server%" equ "true" (
				echo   %fg`white%1%`r% %fg`black%-%`r% %fg`green%Rock%`r%
				echo   %fg`white%2%`r% %fg`black%-%`r% %fg`green%Paper%`r%
				echo   %fg`white%3%`r% %fg`black%-%`r% %fg`green%Scissors%`r%
				echo   %fg`white%x%`r% %fg`black%-%`r% %fg`white%Back%`r%
			) else (
				echo   %fg`white%1%`r% %fg`black%-%`r% %fg`red%Rock%`r%
				echo   %fg`white%2%`r% %fg`black%-%`r% %fg`red%Paper%`r%
				echo   %fg`white%3%`r% %fg`black%-%`r% %fg`red%Scissors%`r%
				echo   %fg`white%x%`r% %fg`black%-%`r% %fg`white%Back%`r%
			)
			echo.
			set /p "player-one-choice=%fg`black%[%fg`yellow%%points_one%%fg`black%/%fg`yellow%%points_two%%fg`black%]%`r% -> "

			if "%player-one-choice%" equ "1" set "player-one-choice-name=rock"
			if "%player-one-choice%" equ "2" set "player-one-choice-name=paper"
			if "%player-one-choice%" equ "3" set "player-one-choice-name=scissors"
			if "%player-one-choice%" equ "x" (
				echo %player-one-choice% | ptnio -id:%ptnio_id% -c nms_send s
				ptnio -id:%ptnio_id% -c free s >nul 2>&1
				ptnio -id:%ptnio_id% -c free listener >nul 2>&1
				goto :select
			)

			echo %player-one-choice% | ptnio -id:%ptnio_id% -c nms_send s
			for /f "tokens=*" %%a in ('ptnio -id:%ptnio_id% -c nms_recv s') do set player-two-choice=%%a
			set player-two-choice=%player-two-choice: =%
			echo %player-one-choice-name% | ptnio -id:%ptnio_id% -c nms_send s
			for /f "tokens=*" %%a in ('ptnio -id:%ptnio_id% -c nms_recv s') do set player-two-choice-name=%%a
			set player-two-choice-name=%player-two-choice-name: =%

			if "%player-two-choice%" equ "x" (
				ptnio -id:%ptnio_id% -c free s >nul 2>&1
				ptnio -id:%ptnio_id% -c free listener >nul 2>&1
				goto :select
			)

			if "%player-one-choice%" equ "1" (
				if "%player-two-choice%" equ "1" (
					set "player-one-won=false"
					set "player-two-won=false"
				)
				if "%player-two-choice%" equ "2" (
					set "player-one-won=false"
					set "player-two-won=true"
				)
				if "%player-two-choice%" equ "3" (
					set "player-one-won=true"
					set "player-two-won=false"
				)
			)
			if "%player-one-choice%" equ "2" (
				if "%player-two-choice%" equ "1" (
					set "player-one-won=true"
					set "player-two-won=false"
				)
				if "%player-two-choice%" equ "2" (
					set "player-one-won=false"
					set "player-two-won=false"
				)
				if "%player-two-choice%" equ "3" (
					set "player-one-won=false"
					set "player-two-won=true"
				)
			)
			if "%player-one-choice%" equ "3" (
				if "%player-two-choice%" equ "1" (
					set "player-one-won=false"
					set "player-two-won=true"
				)
				if "%player-two-choice%" equ "2" (
					set "player-one-won=true"
					set "player-two-won=false"
				)
				if "%player-two-choice%" equ "3" (
					set "player-one-won=false"
					set "player-two-won=false"
				)
			)

			echo.
			echo   %player_one_nickname%'s %fg`black%^(You^)%`r% choice: %fg`green%%player-one-choice-name%%`r%
			echo   %player_two_nickname%'s choice: %fg`green%%player-two-choice-name%%`r%
			echo.
			if "%player-one-won%" equ "true" (
				echo %fg`yellow%1 point%`r% goes to %fg`cyan%%player_one_nickname%%`r% %fg`black%^(You^)%`r%.
				set /a points_one+=1
			) else if "%player-two-won%" equ "true" (
				echo %fg`yellow%1 point%`r% goes to %fg`cyan%%player_two_nickname%%`r%.
				set /a points_two+=1
			) else (
				echo %fg`red%Draw%`r%.
			)

			timeout 3000
			goto :multiplayer-tcpip-connect-loop

:multiplayer-hotseat
	set points_one=0
	set points_two=0
	echo.
	echo Player %fg`green%ONE%`r% nickname:
	echo.
	set /p "player-one-nickname=-> "
	echo.
	echo Player %fg`red%TWO%`r% nickname:
	echo.
	set /p "player-two-nickname=-> "

	:multiplayer-hotseat-loop
		cls
		echo %player-one-nickname%'s turn:
		echo.
		echo   %fg`white%1%`r% %fg`black%-%`r% %fg`green%Rock%`r%
		echo   %fg`white%2%`r% %fg`black%-%`r% %fg`green%Paper%`r%
		echo   %fg`white%3%`r% %fg`black%-%`r% %fg`green%Scissors%`r%
		echo   %fg`white%x%`r% %fg`black%-%`r% %fg`white%Back%`r%
		echo.
		set /p "player-one-choice=%fg`black%[%fg`yellow%%points_one%%fg`black%/%fg`yellow%%points_two%%fg`black%]%`r% -> "

		if "%player-one-choice%" equ "1" set "player-one-choice-name=rock"
		if "%player-one-choice%" equ "2" set "player-one-choice-name=paper"
		if "%player-one-choice%" equ "3" set "player-one-choice-name=scissors"
		if "%player-one-choice%" equ "x" goto :select

		cls
		echo %player-two-nickname%'s turn:
		echo.
		echo   %fg`white%1%`r% %fg`black%-%`r% %fg`red%Rock%`r%
		echo   %fg`white%2%`r% %fg`black%-%`r% %fg`red%Paper%`r%
		echo   %fg`white%3%`r% %fg`black%-%`r% %fg`red%Scissors%`r%
		echo   %fg`white%x%`r% %fg`black%-%`r% %fg`white%Back%`r%
		echo.
		set /p "player-two-choice=%fg`black%[%fg`yellow%%points_one%%fg`black%/%fg`yellow%%points_two%%fg`black%]%`r% -> "

		if "%player-two-choice%" equ "1" set "player-two-choice-name=rock"
		if "%player-two-choice%" equ "2" set "player-two-choice-name=paper"
		if "%player-two-choice%" equ "3" set "player-two-choice-name=scissors"
		if "%player-two-choice%" equ "x" goto :select

		if "%player-one-choice%" equ "1" (
			if "%player-two-choice%" equ "1" (
				set "player-one-won=false"
				set "player-two-won=false"
			)
			if "%player-two-choice%" equ "2" (
				set "player-one-won=false"
				set "player-two-won=true"
			)
			if "%player-two-choice%" equ "3" (
				set "player-one-won=true"
				set "player-two-won=false"
			)
		)
		if "%player-one-choice%" equ "2" (
			if "%player-two-choice%" equ "1" (
				set "player-one-won=true"
				set "player-two-won=false"
			)
			if "%player-two-choice%" equ "2" (
				set "player-one-won=false"
				set "player-two-won=false"
			)
			if "%player-two-choice%" equ "3" (
				set "player-one-won=false"
				set "player-two-won=true"
			)
		)
		if "%player-one-choice%" equ "3" (
			if "%player-two-choice%" equ "1" (
				set "player-one-won=false"
				set "player-two-won=true"
			)
			if "%player-two-choice%" equ "2" (
				set "player-one-won=true"
				set "player-two-won=false"
			)
			if "%player-two-choice%" equ "3" (
				set "player-one-won=false"
				set "player-two-won=false"
			)
		)

		echo.
		echo   %player-one-nickname%'s choice: %fg`green%%player-one-choice-name%%`r%
		echo   %player-two-nickname%'s choice: %fg`green%%player-two-choice-name%%`r%
		echo.
		if "%player-one-won%" equ "true" (
			echo %fg`yellow%1 point%`r% goes to %fg`cyan%%player-one-nickname%%`r%.
			set /a points_one+=1
		) else if "%player-two-won%" equ "true" (
			echo %fg`yellow%1 point%`r% goes to %fg`cyan%%player-two-nickname%%`r%.
			set /a points_two+=1
		) else (
			echo %fg`red%Draw%`r%.
		)

		timeout 3000
		goto :multiplayer-hotseat-loop

:singleplayer
	set points=0
	echo.
	echo Select bot difficulty:
	echo.
	echo   %fg`white%1%`r% %fg`black%-%`r% %fg`green%Easy%`r% %fg`black%^(never lose^)%`r%
	echo   %fg`white%2%`r% %fg`black%-%`r% %fg`yellow%Medium%`r% %fg`black%^(random method^)%`r%
	echo   %fg`white%3%`r% %fg`black%-%`r% %fg`red%Hard%`r% %fg`black%^(probability method^)%`r%
	echo   %fg`white%4%`r% %fg`black%-%`r% %fg`cyan%Impossible%`r% %fg`black%^(never win^)%`r%
	echo   %fg`white%x%`r% %fg`black%-%`r% %fg`white%Back%`r%
	echo.

	set /p "choice=-> "

	if "%choice%" equ "1" (
		goto :easy
	) else if "%choice%" equ "2" (
		goto :medium
	) else if "%choice%" equ "3" (
		goto :hard
	) else if "%choice%" equ "4" (
		goto :impossible
	) else if "%choice%" equ "x" (
		goto :select
	) else (
		goto :singleplayer
	)

:easy
	cls
	echo Your turn:
	echo.
	echo   %fg`white%1%`r% %fg`black%-%`r% %fg`green%Rock%`r%
	echo   %fg`white%2%`r% %fg`black%-%`r% %fg`green%Paper%`r%
	echo   %fg`white%3%`r% %fg`black%-%`r% %fg`green%Scissors%`r%
	echo   %fg`white%x%`r% %fg`black%-%`r% %fg`white%Back%`r%
	echo.

	set /p "human=%fg`black%[%`r%%fg`yellow%%points%%`r%%fg`black%]%`r% -> "
	if "%human%" equ "1" (
		set bot=3
	) else if "%human%" equ "2" (
		set bot=1
	) else if "%human%" equ "3" (
		set bot=2
	) else if "%human%" equ "x" (
		cls
		goto :select
	) else (
		goto :easy
	)
	echo.

	if "%human%" equ "1" set "humanChoice=rock"
	if "%human%" equ "2" set "humanChoice=paper"
	if "%human%" equ "3" set "humanChoice=scissors"

	if "%bot%" equ "1" set "botChoice=rock"
	if "%bot%" equ "2" set "botChoice=paper"
	if "%bot%" equ "3" set "botChoice=scissors"

	if "%human%" equ "1" if "%bot%" equ "1" set "score=none"
	if "%human%" equ "2" if "%bot%" equ "1" set "score=human"
	if "%human%" equ "3" if "%bot%" equ "1" set "score=bot"

	if "%human%" equ "1" if "%bot%" equ "2" set "score=bot"
	if "%human%" equ "2" if "%bot%" equ "2" set "score=none"
	if "%human%" equ "3" if "%bot%" equ "2" set "score=human"

	if "%human%" equ "1" if "%bot%" equ "3" set "score=human"
	if "%human%" equ "2" if "%bot%" equ "3" set "score=bot"
	if "%human%" equ "3" if "%bot%" equ "3" set "score=none"

	echo   Your choice: %fg`green%%humanChoice%%`r%
	echo   Bot choice: %fg`green%%botChoice%%`r%
	echo.

	if "%score%" equ "human" echo %fg`yellow%1 point%`r% goes to %fg`cyan%human%`r%. & set /a points+=1
	if "%score%" equ "bot" echo %fg`yellow%1 point%`r% goes to %fg`cyan%bot%`r%. & set /a points-=1
	if "%score%" equ "none" echo %fg`red%Draw%`r%.

	timeout 3000
	goto :easy

:medium
	cls
	echo Your turn:
	echo.
	echo   %fg`white%1%`r% %fg`black%-%`r% %fg`yellow%Rock%`r%
	echo   %fg`white%2%`r% %fg`black%-%`r% %fg`yellow%Paper%`r%
	echo   %fg`white%3%`r% %fg`black%-%`r% %fg`yellow%Scissors%`r%
	echo   %fg`white%x%`r% %fg`black%-%`r% %fg`white%Back%`r%
	echo.

	set /p "human=%fg`black%[%`r%%fg`yellow%%points%%`r%%fg`black%]%`r% -> "
	call :random 3
	set "bot=!rand!"
	echo.

	if "%human%" equ "1" (
		set "humanChoice=rock"
	) else if "%human%" equ "2" (
		set "humanChoice=paper"
	) else if "%human%" equ "3" (
		set "humanChoice=scissors"
	) else if "%human%" equ "x" (
		cls
		goto :select
	) else (
		goto :medium
	)

	if "%bot%" equ "1" set "botChoice=rock"
	if "%bot%" equ "2" set "botChoice=paper"
	if "%bot%" equ "3" set "botChoice=scissors"

	if "%human%" equ "1" if "%bot%" equ "1" set "score=none"
	if "%human%" equ "2" if "%bot%" equ "1" set "score=human"
	if "%human%" equ "3" if "%bot%" equ "1" set "score=bot"

	if "%human%" equ "1" if "%bot%" equ "2" set "score=bot"
	if "%human%" equ "2" if "%bot%" equ "2" set "score=none"
	if "%human%" equ "3" if "%bot%" equ "2" set "score=human"

	if "%human%" equ "1" if "%bot%" equ "3" set "score=human"
	if "%human%" equ "2" if "%bot%" equ "3" set "score=bot"
	if "%human%" equ "3" if "%bot%" equ "3" set "score=none"

	echo   Your choice: %fg`green%%humanChoice%%`r%
	echo   Bot choice: %fg`green%%botChoice%%`r%
	echo.

	if "%score%" equ "human" echo %fg`yellow%1 point%`r% goes to %fg`cyan%human%`r%. & set /a points+=1
	if "%score%" equ "bot" echo %fg`yellow%1 point%`r% goes to %fg`cyan%bot%`r%. & set /a points-=1
	if "%score%" equ "none" echo %fg`red%Draw%`r%.

	timeout 3000
	goto :medium

:hard
	cls
	echo Your turn:
	echo.
	echo   %fg`white%1%`r% %fg`black%-%`r% %fg`red%Rock%`r%
	echo   %fg`white%2%`r% %fg`black%-%`r% %fg`red%Paper%`r%
	echo   %fg`white%3%`r% %fg`black%-%`r% %fg`red%Scissors%`r%
	echo   %fg`white%x%`r% %fg`black%-%`r% %fg`white%Back%`r%
	echo.

	set /p "human=%fg`black%[%`r%%fg`yellow%%points%%`r%%fg`black%]%`r% -> "
	if "%human%" equ "1" (
		set "humanChoice=rock"
	) else if "%human%" equ "2" (
		set "humanChoice=paper"
	) else if "%human%" equ "3" (
		set "humanChoice=scissors"
	) else if "%human%" equ "x" (
		cls
		goto :select
	) else (
		goto :hard
	)

	if exist "data.txt" (
		set lines=0 & for /f %%i in (data.txt) do (set /a lines+=1)
		if !lines! geq 6 del /f /q data.txt >nul
	)

	echo !human!>> "data.txt"
	set rockNum=0 & set paperNum=0 & set scissorsNum=0
	for /f %%i in (data.txt) do (
		if "%%i" equ "1" set /a rockNum+=1
		if "%%i" equ "2" set /a paperNum+=1
		if "%%i" equ "3" set /a scissorsNum+=1
	)

	if %rockNum% gtr %paperNum% (
		if %rockNum% gtr %scissorsNum% set bot=2
		if %rockNum% equ %scissorsNum% (
			call :random 2
			if "!rand!" equ "1" set "botChoice=rock"
			if "!rand!" equ "2" set "botChoice=scissors"
		)
	)
	if %paperNum% gtr %scissorsNum% (
		if %paperNum% gtr %rockNum% set bot=3
		if %paperNum% equ %rockNum% (
			call :random 2
			if "!rand!" equ "1" set "botChoice=paper"
			if "!rand!" equ "2" set "botChoice=rock"
		)
	)
	if %scissorsNum% gtr %rockNum% (
		if %scissorsNum% gtr %paperNum% set bot=1
		if %scissorsNum% equ %paperNum% (
			call :random 2
			if "!rand!" equ "1" set "botChoice=scissors"
			if "!rand!" equ "2" set "botChoice=paper"
		)
	)

	if %rockNum% gtr %scissorsNum% (
		if %rockNum% gtr %paperNum% set bot=2
		if %rockNum% equ %paperNum% (
			call :random 2
			if "!rand!" equ "1" set "botChoice=rock"
			if "!rand!" equ "2" set "botChoice=paper"
		)
	)
	if %paperNum% gtr %rockNum% (
		if %paperNum% gtr %scissorsNum% set bot=3
		if %paperNum% equ %scissorsNum% (
			call :random 2
			if "!rand!" equ "1" set "botChoice=paper"
			if "!rand!" equ "2" set "botChoice=scissors"
		)
	)
	if %scissorsNum% gtr %paperNum% (
		if %scissorsNum% gtr %rockNum% set bot=1
		if %scissorsNum% equ %rockNum% (
			call :random 2
			if "!rand!" equ "1" set "botChoice=scissors"
			if "!rand!" equ "2" set "botChoice=rock"
		)
	)

	if %rockNum% equ %paperNum% if %paperNum% equ %scissorsNum% (
		call :random 3
		set "bot=!rand!"
		if "%bot%" equ "1" set "botChoice=rock"
		if "%bot%" equ "2" set "botChoice=paper"
		if "%bot%" equ "3" set "botChoice=scissors"
	)

	if %rockNum% equ 0 (
		call :random 3
		set "bot=!rand!"
		if "%bot%" equ "1" set "botChoice=rock"
		if "%bot%" equ "2" set "botChoice=paper"
		if "%bot%" equ "3" set "botChoice=scissors"
	)
	if %paperNum% equ 0 (
		call :random 3
		set "bot=!rand!"
		if "%bot%" equ "1" set "botChoice=rock"
		if "%bot%" equ "2" set "botChoice=paper"
		if "%bot%" equ "3" set "botChoice=scissors"
	)
	if %paperNum% equ 0 (
		call :random 3
		set "bot=!rand!"
		if "%bot%" equ "1" set "botChoice=rock"
		if "%bot%" equ "2" set "botChoice=paper"
		if "%bot%" equ "3" set "botChoice=scissors"
	)

	echo.

	if "%humanChoice%" equ "rock" if "%botChoice%" equ "rock" set "score=none"
	if "%humanChoice%" equ "paper" if "%botChoice%" equ "rock" set "score=human"
	if "%humanChoice%" equ "scissors" if "%botChoice%" equ "rock" set "score=bot"

	if "%humanChoice%" equ "rock" if "%botChoice%" equ "paper" set "score=bot"
	if "%humanChoice%" equ "paper" if "%botChoice%" equ "paper" set "score=none"
	if "%humanChoice%" equ "scissors" if "%botChoice%" equ "paper" set "score=human"

	if "%humanChoice%" equ "rock" if "%botChoice%" equ "scissors" set "score=human"
	if "%humanChoice%" equ "paper" if "%botChoice%" equ "scissors" set "score=bot"
	if "%humanChoice%" equ "scissors" if "%botChoice%" equ "scissors" set "score=none"

	echo   Your choice: %fg`green%%humanChoice%%`r%
	echo   Bot choice: %fg`green%%botChoice%%`r%
	echo.

	if "%score%" equ "human" echo %fg`yellow%1 point%`r% goes to %fg`cyan%human%`r%. & set /a points+=1
	if "%score%" equ "bot" echo %fg`yellow%1 point%`r% goes to %fg`cyan%bot%`r%. & set /a points-=1
	if "%score%" equ "none" echo %fg`red%Draw%`r%.

	timeout 3000
	goto :hard

:impossible
	cls
	echo Your turn:
	echo.
	echo   %fg`white%1%`r% %fg`black%-%`r% %fg`cyan%Rock%`r%
	echo   %fg`white%2%`r% %fg`black%-%`r% %fg`cyan%Paper%`r%
	echo   %fg`white%3%`r% %fg`black%-%`r% %fg`cyan%Scissors%`r%
	echo   %fg`white%x%`r% %fg`black%-%`r% %fg`white%Back%`r%
	echo.

	set /p "human=%fg`black%[%`r%%fg`yellow%%points%%`r%%fg`black%]%`r% -> "
	if "%human%" equ "1" (
		set bot=2
	) else if "%human%" equ "2" (
		set bot=3
	) else if "%human%" equ "3" (
		set bot=1
	) else if "%human%" equ "x" (
		cls
		goto :select
	) else (
		goto :impossible
	)
	echo.

	if "%human%" equ "1" set "humanChoice=rock"
	if "%human%" equ "2" set "humanChoice=paper"
	if "%human%" equ "3" set "humanChoice=scissors"

	if "%bot%" equ "1" set "botChoice=rock"
	if "%bot%" equ "2" set "botChoice=paper"
	if "%bot%" equ "3" set "botChoice=scissors"

	if "%human%" equ "1" if "%bot%" equ "1" set "score=none"
	if "%human%" equ "2" if "%bot%" equ "1" set "score=human"
	if "%human%" equ "3" if "%bot%" equ "1" set "score=bot"

	if "%human%" equ "1" if "%bot%" equ "2" set "score=bot"
	if "%human%" equ "2" if "%bot%" equ "2" set "score=none"
	if "%human%" equ "3" if "%bot%" equ "2" set "score=human"

	if "%human%" equ "1" if "%bot%" equ "3" set "score=human"
	if "%human%" equ "2" if "%bot%" equ "3" set "score=bot"
	if "%human%" equ "3" if "%bot%" equ "3" set "score=none"

	echo   Your choice: %fg`green%%humanChoice%%`r%
	echo   Bot choice: %fg`green%%botChoice%%`r%
	echo.

	if "%score%" equ "human" echo %fg`yellow%1 point%`r% goes to %fg`cyan%human%`r%. & set /a points+=1
	if "%score%" equ "bot" echo %fg`yellow%1 point%`r% goes to %fg`cyan%bot%`r%. & set /a points-=1
	if "%score%" equ "none" echo %fg`red%Draw%`r%.

	timeout 3000
	goto :impossible

:random
	set /a rand=%random% * %1 / 32768 + 1
	exit /b

:cl
	set `r=[0m&set `b=[1m&set `u=[4m&set `i=[7m&set fg`black-=[30m&set fg`red-=[31m&set fg`green-=[32m&set fg`yellow-=[33m&set fg`blue-=[34m&set fg`magenta-=[35m&set fg`cyan-=[36m&set fg`white-=[37m&set fg`black=[90m&set fg`red=[91m&set fg`green=[92m&set fg`yellow=[93m&set fg`blue=[94m&set fg`magenta=[95m&set fg`cyan=[96m&set fg`white=[97m&set bg`black-=[40m&set bg`red-=[41m&set bg`green-=[42m&set bg`yellow-=[43m&set bg`blue-=[44m&set bg`magenta-=[45m&set bg`cyan-=[46m&set bg`white-=[47m&set bg`black=[100m&set bg`red=[101m&set bg`green=[102m&set bg`yellow=[103m&set bg`blue=[104m&set bg`magenta=[105m&set bg`cyan=[106m&set bg`white=[107m
	exit /b