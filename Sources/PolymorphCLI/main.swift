import PolymorphCore
import CommandLineArgs

var arguments = CommandLine.arguments
arguments[0] = PolymorphCommand.Consts.name

let cla = CommandLineArgs()
let polymorph = cla.root(command: PolymorphCommand())
let projectCommands = polymorph.add(child: ProjectCommand())
projectCommands.add(child: InitProjectCommand())
projectCommands.add(child: InfoProjectCommand())
projectCommands.add(child: UpdateProjectCommand())
projectCommands.add(child: RemoveProjectCommand())

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

let serviceCommands = polymorph.add(child: ServiceCommand())
serviceCommands.add(child: NewServiceCommand())

let externalCommands = polymorph.add(child: ExternalCommand())
externalCommands.add(child: NewExternalCommand())
externalCommands.add(child: ListExternalCommand())
externalCommands.add(child: UpdateExternalCommand())
externalCommands.add(child: RemoveExternalCommand())

polymorph.add(child: BuildCommand())

let nativeCommands = polymorph.add(child: NativeCommand())
nativeCommands.add(child: ListNativeCommand())

let transfomerCommands = polymorph.add(child: TransformerCommand())
transfomerCommands.add(child: ListTransformerCommand())

cla.handle(arguments)
