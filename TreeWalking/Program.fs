open System
open System.IO

let run (sourceCode:string) =
    printfn "run"

let runPrompt () =
    Console.R

let runFile path =
    File.ReadAllText path
    |> run
    printfn "runFile"

[<EntryPoint>]
let main argv =

    if argv.Length > 1 then
        printfn "Usage: flox [script]"
        exit(64)
    else if argv.Length = 1 then
        runFile(argv.[0])
    else
        runPrompt()
    0
