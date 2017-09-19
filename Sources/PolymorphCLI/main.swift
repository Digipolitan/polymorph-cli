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
classCommands.add(child: RemoveClassCommand())

let propertyCommands = classCommands.add(child: ClassPropertyCommand())
propertyCommands.add(child: ClassNewPropertyCommand())
propertyCommands.add(child: ClassRemovePropertyCommand())
propertyCommands.add(child: ClassUpdatePropertyCommand())

let enumCommands = polymorph.add(child: EnumCommand())
enumCommands.add(child: NewEnumCommand())
enumCommands.add(child: ListEnumCommand())
enumCommands.add(child: RemoveEnumCommand())
enumCommands.add(child: EnumValueCommand())
let valueCommands = enumCommands.add(child: EnumValueCommand())
valueCommands.add(child: EnumNewValueCommand())

polymorph.add(child: BuildCommand())

cla.handle(arguments)
