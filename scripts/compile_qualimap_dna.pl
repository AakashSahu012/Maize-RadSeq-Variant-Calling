@files = <*/genome_results.txt>;

print "Sample\tTotal_reads\tTotal_reads_mapped\tReads_mapped_inPair\tCoverage\n";
foreach $val (@files)
{
  open(DATA, $val);
  while(<DATA>)
  {
    
    $id = (split /\//, $val)[0];
    if(/number of reads/)
    {  
      $tr = (split /\=/, $_)[1]; $tr =~ s/\s|\,//g; 
    }
    elsif(/number of mapped reads/)
    {
      $tmr = (split /\=/, $_)[1]; $tmr =~ s/\s|\,//g; 
    }
    elsif(/number of mapped paired reads \(both in pair\)/)
    {
      $tmpr = (split /\=/, $_)[1]; $tmpr =~ s/\s|\,//g; 
    }
    elsif(/mean coverageData/)
    {
      $cov = (split /\=/, $_)[1]; $cov =~ s/\s|\,//g; 
    }
     
  }
  close(DATA);
  #$per = sprintf("%.2f", ((($rpa*2)/$ta)*100));
  print $id."\t".$tr."\t".$tmr."\t".$tmpr."\t".$cov."\n";
} 
