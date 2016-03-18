<?php
namespace MongoDB\Driver;

class ReadPreference
{
	const RP_PRIMARY = 1 ;
	const RP_PRIMARY_PREFERRED = 5 ;
	const RP_SECONDARY = 2 ;
	const RP_SECONDARY_PREFERRED = 6 ;
	const RP_NEAREST = 10 ;

	public function __construct($mode = '', $tagSets = [])
	{

	}

}
