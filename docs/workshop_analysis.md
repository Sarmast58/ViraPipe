# ViraPipe: Workshop Sequencing Analysis



## 1. Project Overview



This report documents an exploratory bioinformatics analysis of publicly available Illumina sequencing data using FastQC, Trimmomatic, Bowtie2, Minimap2, Samtools, and Kraken2.



The objective was to assess sequencing quality, perform read preprocessing, evaluate reference-based alignment, and investigate taxonomic classifications.



## 2. Dataset Information



\- \*\*ENA run accession:\*\* ERR6913101

\- \*\*Study accession:\*\* PRJEB47870

\- \*\*Sequencing platform:\*\* Illumina NovaSeq 6000

\- \*\*Library layout:\*\* Paired-end

\- \*\*Library source:\*\* Metagenomic

\- \*\*Library strategy:\*\* OTHER

\- \*\*Dataset source:\*\* European Nucleotide Archive / JHUAPL workshop materials



## 3. Quality Control and Trimming



FastQC was used to generate quality-control reports for sequencing reads.



Trimmomatic v0.39 was applied using the following parameters:



\- `PE`

\- `-phred33`

\- `SLIDINGWINDOW:4:20`

\- `MINLEN:25`



### Trimmomatic Results



| Metric | Read pairs | Percentage |

|---|---:|---:|

| Input | 329,134 | 100% |

| Both surviving | 328,053 | 99.67% |

| Forward only surviving | 492 | 0.15% |

| Reverse only surviving | 574 | 0.17% |

| Dropped | 15 | Less than 0.01% |



The high read-pair retention indicates that most input pairs passed the selected quality-trimming thresholds. Adapter trimming was not performed.



## 4. Reference-Based Alignment

### Reference Genome
The SARS-CoV-2 reference genome used for alignment was identified by GenBank accession MN908947.3. The local FASTA file, reference/nCoV-2019.reference.fasta, contains 29,903 nucleotide characters.

Bowtie2 indexes were generated from this reference using bowtie2-build. Both Bowtie2 and Minimap2 were subsequently tested against the same reference sequence.

The accession and sequence length were checked locally. Exact sequence identity against the GenBank record has not yet been independently verified.

Trimmed paired-end reads were aligned against the SARS-CoV-2 reference genome supplied with the workshop.



### Alignment Results



| Tool | Result |

|---|---|

| Bowtie2 | 0.04% overall alignment rate |

| Minimap2 v2.17-r941 (`sr` preset) | Approximately 0.04% mapped alignment records |

| Samtools | 256 mapped alignment records, including supplementary records |



Both aligners produced very low alignment rates against the selected SARS-CoV-2 reference. These results indicate poor mapping to this particular reference, rather than establishing sequencing failure.



## 5. Kraken2 Taxonomic Classification



Kraken2 v2.0.7-beta was used with the workshop's `flukraken2` database.



The database was built in November 2021 using influenza-related reference sequences from the NCBI Influenza Virus Resource and a custom taxonomy.



### Classification Results



| Classification | Read pairs | Percentage |

|---|---:|---:|

| Classified | 20,328 | 6.20% |

| Unclassified | 307,725 | 93.80% |

| Total analyzed | 328,053 | 100% |



### Selected Taxonomic Assignments



| Taxon | Read pairs in clade | Percentage of all analyzed pairs |

|---|---:|---:|

| Influenza A virus | 18,726 | 5.71% |

| Influenza B virus | 1,466 | 0.45% |

| Influenza C virus | 110 | 0.03% |



These classifications represent taxonomic assignments against an influenza-focused database. They do not independently confirm the presence of each species or establish coinfection.



## 6. Interpretation



The initial reference-based alignment yielded very few matches to SARS-CoV-2.



Subsequent Kraken2 analysis identified influenza-related sequence classifications, suggesting that the metagenomic dataset contains reads matching influenza reference sequences.



However, the limited scope of the Kraken2 database prevents comprehensive characterization of microbial diversity. The unclassified fraction may contain sequences not represented in the reference database.



## 7. Limitations



\- FastQC summary metrics have not yet been quantitatively documented.

\- Adapter removal was not included in preprocessing.

\- The SARS-CoV-2 reference may not reflect the principal sequence composition of the metagenomic dataset.

\- The influenza-specific Kraken2 database cannot classify all possible microbial taxa.

\- Taxonomic assignments require additional validation before making organism- or subtype-level biological claims.

\- This analysis is exploratory and is not a validated diagnostic workflow.



## 8. Reproducibility



Analyses were performed on Windows using Docker and the `jhuaplbio/sandbox` environment. The analysis scripts and documentation are maintained in the ViraPipe GitHub repository.



The underlying workshop commands informed the workflow, while the project organizes the tested steps and their interpretation for educational use.

