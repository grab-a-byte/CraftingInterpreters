module Errors

open System

let report line where message =
    sprintf "[line %i] Error %s : %s" line where message
    |> Console.Error.WriteLine

let error line message=
    report line "" message