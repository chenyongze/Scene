<?php
namespace MongoDB\Driver;

class WriteConcern
{
	const MAJORITY = 'majority';

	public function __construct($w = '', $wtimeout = 1000, $journay = false)
	{

	}
}
