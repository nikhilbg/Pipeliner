rule mutect:
       input:  normal=lambda wildcards: config['project']['pairs'][wildcards.x][0]+".recal.bam",
               tumor=lambda wildcards: config['project']['pairs'][wildcards.x][1]+".recal.bam"
       output: vcf="mutect_out/{x}.vcf",
               stats="mutect_out/{x}.stats.out",
               vcfRename="mutect_out/{x}.FINAL.vcf"
       params: normalsample=lambda wildcards: config['project']['pairs'][wildcards.x][0],tumorsample=lambda wildcards: config['project']['pairs'][wildcards.x][1],targets=config['references'][pfamily]['REFFLAT'],knowns=config['references'][pfamily]['MUTECTVARIANTS'],mutect=config['bin'][pfamily]['MUTECT'],gatk=config['bin'][pfamily]['GATK'],genome=config['references'][pfamily]['MUTECTGENOME'],cosmic=config['references'][pfamily]['MUTECTCOSMIC'],snp=config['references'][pfamily]['MUTECTSNP'],rname="pl:mutect"
       shell:  "{params.mutect} --analysis_type MuTect --reference_sequence {params.genome} --vcf {output.vcf} {params.knowns} --intervals {params.targets} --input_file:normal {input.normal} --input_file:tumor {input.tumor} --out {output.stats} -rf BadCigar; {params.gatk} -T SelectVariants -R {params.genome} --variant {output.vcf} --excludeFiltered -o {output.vcfRename}"