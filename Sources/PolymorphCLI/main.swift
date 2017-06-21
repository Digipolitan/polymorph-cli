import PolymorphCore
import CommandLineArgs

var arguments = CommandLine.arguments
arguments.remove(at: 0)

let cla = CommandLineArgs(name: "polymorph", documentation: "Command line tools to generate source code files")
cla.main(command: UseProjectCommand())
cla.register(command: InitProjectCommand())
cla.register(command: RemoveProjectCommand())
cla.register(command: BuildProjectCommand())

do {
    try cla.run(arguments)
} catch {
    print("\(error)")
}

