import PolymorphCore
import CommandLineArgs

var arguments = CommandLine.arguments
arguments[0] = PolymorphCommand.Consts.name

let cla = CommandLineArgs()
let polymorph = cla.root(command: PolymorphCommand())
polymorph.add(child: UseProjectCommand())
polymorph.add(child: InitProjectCommand())
polymorph.add(child: RemoveProjectCommand())
polymorph.add(child: BuildProjectCommand())

do {
    let task = try cla.build(arguments)
    if let help = task.arguments[PolymorphCommand.Keys.help] as? Bool, help == true {
        print(task.help())
    } else {
        do {
            try task.exec()
        } catch CommandLineError.unimplementedCommand {
            print(task.help())
        }
    }
} catch CommandLineError.missingRequiredArgument(let node) {
    print("[!] Missing required parameter\n")
    print(node.help())
} catch CommandLineError.commandNotFound {
    print("[!] Command not found\n")
    print(cla.help())
} catch {
    print("[!] Unexpected error occured: \(error)")
}

