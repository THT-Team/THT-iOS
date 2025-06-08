import ProjectDescription

let tuist = Tuist(
  project: .tuist(
    compatibleXcodeVersions: .all,
    swiftVersion: .some(.init(5, 8, 0)),
    plugins: [
      .local(path: .relativeToManifest("../Plugins/THTIOSHappyNewYear")),
    ],
    generationOptions: .options(),
    installOptions: .options()
  )
)
