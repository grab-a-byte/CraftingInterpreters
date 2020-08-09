open System
open System.IO
open Scanner

let run (sourceCode:string) =
    scanTokens sourceCode |> List.map (printfn "%s") |> ignore

let runPrompt () =
    printfn ">"
    Console.ReadLine() |> run

let runFile path =
    File.ReadAllText path
    |> run

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
