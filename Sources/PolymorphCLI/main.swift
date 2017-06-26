import PolymorphCore
import CommandLineArgs

var arguments = CommandLine.arguments
arguments[0] = PolymorphCommand.Consts.name

let cla = CommandLineArgs()
let polymorph = cla.root(command: PolymorphCommand())
polymorph.add(child: InitProjectCommand())
polymorph.add(child: UpdateProjectCommand())
polymorph.add(child: RemoveProjectCommand())

let classCommands = polymorph.add(child: ClassCommand())
classCommands.add(child: NewClassCommand())
classCommands.add(child: ListClassCommand())
classCommands.add(child: UpdateClassCommand())
let propertyCommands = classCommands.add(child: ClassPropertyCommand())
propertyCommands.add(child: ClassNewPropertyCommand())

polymorph.add(child: BuildProjectCommand())

cla.handle(arguments)
