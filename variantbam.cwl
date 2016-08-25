#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: CommandLineTool
id: "VariantBam"
label: "VariantBam"

description: |
    This is the VariantBam tool used in the PCAWG project.
    VariantBam was created by Jeremiah Wala (jwala@broadinstitute.org).
    This CWL wrapper was created by Solomon Shorser.
    For more information about VariantBam, see: https://github.com/jwalabroad/VariantBam

dct:creator:
    foaf:name: "Solomon Shorser"
    foaf:mbox: "solomon.shorser@oicr.on.ca"

dct:contributor:
  foaf:name: "Jeremiah Wala"
  foaf:mbox: "jwala@broadinstitute.org"

requirements:
    - class: DockerRequirement
      dockerPull: quay.io/pancancer/variantbam
    - class: InlineJavascriptRequirement

stdout: stdout.txt
stderr: stderr.txt

inputs:
    - id: "#input-bam"
      type: File
      inputBinding:
        position: 1
        prefix: "-i"
    - id: "#outfile"
      type: string
      inputBinding:
        position: 2
        prefix: "-o"
    - id: "#input-snv"
      type: File
      inputBinding:
        position: 3
        prefix: "-l"
    - id: "#input-sv"
      type: File
      inputBinding:
        position: 4
        prefix: "-l"
    - id: "#input-indel"
      type: File
      inputBinding:
        position: 5
        prefix: "-l"
    - id: "#snv-padding"
      type: string
    - id: "#sv-padding"
      type: string
    - id: "#indel-padding"
      type: string

arguments:
    - valueFrom: $("pad["+inputs['sv-padding']+"];mlregion@/"+inputs['input-sv'].path+"%pad["+inputs['snv-padding']+"];mlregion@/"+inputs['input-snv'].path+"%pad["+inputs['indel-padding']+"]mlregion@/"+inputs['input-indel'].path)
      prefix: "-r"
      position: 5

outputs:
    - id: "#minibam"
      type: File
      outputBinding:
        glob: $(inputs.outfile)

baseCommand: variant
