@echo off
setlocal EnableDelayedExpansion
call :cl
color 07
if exist data.txt del /f /q data.txt >nul
for /f %%i in (block.chr) do (set "block=%%i")

:main
    set points=0
    cls
    echo Rock, Paper, Scissors
    echo.
    echo   %fg`black%Programmed by hXR16F%`r%
    echo   %fg`black%https://github.com/hXR16F%`r%
    echo.
    echo Select bot difficulty:
    echo.
    echo   %fg`white%1%`r% %fg`black%-%`r% %fg`green%Easy%`r% %fg`black%^(never lose^)%`r%
    echo   %fg`white%2%`r% %fg`black%-%`r% %fg`yellow%Medium%`r% %fg`black%^(random method^)%`r%
    echo   %fg`white%3%`r% %fg`black%-%`r% %fg`red%Hard%`r% %fg`black%^(probability method^)%`r%
    echo   %fg`white%4%`r% %fg`black%-%`r% %fg`cyan%Impossible%`r% %fg`black%^(never win^)%`r%
    echo   %fg`white%x%`r% %fg`black%-%`r% %fg`white%Exit%`r%
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
        echo.
        echo   %fg`black%Thank you for playing my game.%`r%
        echo.
        @ping localhost -n 2 >nul
        exit
    ) else (
        goto :main
    )

:easy
    cls
    echo Your turn:
    echo.
    echo   %fg`white%1%`r% %fg`black%-%`r% %fg`green%Rock%`r%
    echo   %fg`white%2%`r% %fg`black%-%`r% %fg`green%Paper%`r%
    echo   %fg`white%3%`r% %fg`black%-%`r% %fg`green%Scissors%`r%
    echo   %fg`white%x%`r% %fg`black%-%`r% %fg`white%Exit%`r%
    echo.

    set /p "human=%fg`black%[%`r%%fg`yellow%%points%%`r%%fg`black%]%`r% -> "
    if "%human%" equ "1" (
        set bot=3
    ) else if "%human%" equ "2" (
        set bot=1
    ) else if "%human%" equ "3" (
        set bot=2
    ) else if "%human%" equ "x" (
        goto :main
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

    @ping localhost -n 3 >nul
    goto :easy

:medium
    cls
    echo Your turn:
    echo.
    echo   %fg`white%1%`r% %fg`black%-%`r% %fg`yellow%Rock%`r%
    echo   %fg`white%2%`r% %fg`black%-%`r% %fg`yellow%Paper%`r%
    echo   %fg`white%3%`r% %fg`black%-%`r% %fg`yellow%Scissors%`r%
    echo   %fg`white%x%`r% %fg`black%-%`r% %fg`white%Exit%`r%
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
        goto :main
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

    @ping localhost -n 3 >nul
    goto :medium

:hard
    cls
    echo Your turn:
    echo.
    echo   %fg`white%1%`r% %fg`black%-%`r% %fg`red%Rock%`r%
    echo   %fg`white%2%`r% %fg`black%-%`r% %fg`red%Paper%`r%
    echo   %fg`white%3%`r% %fg`black%-%`r% %fg`red%Scissors%`r%
    echo   %fg`white%x%`r% %fg`black%-%`r% %fg`white%Exit%`r%
    echo.

    set /p "human=%fg`black%[%`r%%fg`yellow%%points%%`r%%fg`black%]%`r% -> "
    if "%human%" equ "1" (
        set "humanChoice=rock"
    ) else if "%human%" equ "2" (
        set "humanChoice=paper"
    ) else if "%human%" equ "3" (
        set "humanChoice=scissors"
    ) else if "%human%" equ "x" (
        goto :main
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

    @ping localhost -n 3 >nul
    goto :hard

:impossible
    cls
    echo Your turn:
    echo.
    echo   %fg`white%1%`r% %fg`black%-%`r% %fg`cyan%Rock%`r%
    echo   %fg`white%2%`r% %fg`black%-%`r% %fg`cyan%Paper%`r%
    echo   %fg`white%3%`r% %fg`black%-%`r% %fg`cyan%Scissors%`r%
    echo   %fg`white%x%`r% %fg`black%-%`r% %fg`white%Exit%`r%
    echo.

    set /p "human=%fg`black%[%`r%%fg`yellow%%points%%`r%%fg`black%]%`r% -> "
    if "%human%" equ "1" (
        set bot=2
    ) else if "%human%" equ "2" (
        set bot=3
    ) else if "%human%" equ "3" (
        set bot=1
    ) else if "%human%" equ "x" (
        goto :main
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

    @ping localhost -n 3 >nul
    goto :impossible

:random
    set /a rand=%random% * %1 / 32768 + 1
    exit /b

:cl
    set `r=[0m&set `b=[1m&set `u=[4m&set `i=[7m&set fg`black-=[30m&set fg`red-=[31m&set fg`green-=[32m&set fg`yellow-=[33m&set fg`blue-=[34m&set fg`magenta-=[35m&set fg`cyan-=[36m&set fg`white-=[37m&set fg`black=[90m&set fg`red=[91m&set fg`green=[92m&set fg`yellow=[93m&set fg`blue=[94m&set fg`magenta=[95m&set fg`cyan=[96m&set fg`white=[97m&set bg`black-=[40m&set bg`red-=[41m&set bg`green-=[42m&set bg`yellow-=[43m&set bg`blue-=[44m&set bg`magenta-=[45m&set bg`cyan-=[46m&set bg`white-=[47m&set bg`black=[100m&set bg`red=[101m&set bg`green=[102m&set bg`yellow=[103m&set bg`blue=[104m&set bg`magenta=[105m&set bg`cyan=[106m&set bg`white=[107m
    exit /b